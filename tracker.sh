#!/bin/sh

# Bandwidth Download/Upload Rate Counter
LAN_TYPE=$(nvram get lan_ipaddr | awk ' { FS="."; print $1"."$2 }')

# Restore Usage from Back-up
if [ -f /jffs/traffic.bk ]; then
  cat /jffs/traffic.bk | sed 's/{usage:://' | sed 's/;}//' | awk '{split($0, a, ";")} END { for(i in a) printf "%s\n", a[i] }' | awk -F':' ' {split($1, ip, ".")} {printf "export local_%s_upload=%s\nexport local_%s_download=%s\n",ip[4],$2,ip[4],$3}' > /tmp/traffic_bk.sh
  . /tmp/traffic_bk.sh
  rm /tmp/traffic_bk.sh

  cp /jffs/traffic.bk /tmp/www/traffic.asp
fi

while :
do
  # Create the RRDIPT CHAIN (it doesn't matter if it already exists)
  iptables -N RRDIPT 2> /dev/null

  # Add the RRDIPT CHAIN to the FORWARD chain (if non existing)
  iptables -L FORWARD --line-numbers -n | grep "RRDIPT" | grep "1" > /dev/null
  if [ $? -ne 0 ]; then
    iptables -L FORWARD -n | grep "RRDIPT" > /dev/null
    if [ $? -eq 0 ]; then
      iptables -D FORWARD -j RRDIPT
    fi
  iptables -I FORWARD -j RRDIPT
  fi

  # For each host in the ARP table
  grep ${LAN_TYPE} /proc/net/arp | while read IP TYPE FLAGS MAC MASK IFACE
  do
    # Add iptable rules (if non existing)
    iptables -nL RRDIPT | grep "${IP}[[:space:]]" > /dev/null
    if [ $? -ne 0 ]; then
      iptables -I RRDIPT -d ${IP} -j RETURN
      iptables -I RRDIPT -s ${IP} -j RETURN
    fi
  done

  # Update bandwidth total for each client
  echo "add () { echo \$1 \$2 | awk '{ printf \"%.0f\", \$1 + \$2 }'; }" > /tmp/traffic_update.sh
  iptables -L RRDIPT -vnx -t filter | grep ${LAN_TYPE} | awk '{ if ($8 == "0.0.0.0/0") { download[$9]=$2 } else if ($9 == "0.0.0.0/0") upload[$8]=$2 } END { for(item in upload) { {split(item, ip, ".")} { printf "if [ -z ${local_%s_upload+x} ]; then\necho \"%s\:%.0f\:%.0f;\";\nelse\na=`add $local_%s_upload %.0f`;\nb=`add $local_%s_download %.0f`;\necho \"%s\:$a\:$b;\"\nfi\n", ip[4], item, upload[item], download[item], ip[4], upload[item], ip[4], download[item], item}}}' >> /tmp/traffic_update.sh

  echo "{usage::" > /tmp/traffic.dat
  . /tmp/traffic_update.sh >> /tmp/traffic.dat
  echo "}" >> /tmp/traffic.dat

  rm /tmp/traffic_update.sh

  cat /tmp/traffic.dat | sed ':a;N;$!ba;s/\n//g' > /tmp/www/traffic.asp
  cp /tmp/www/traffic.asp /jffs/traffic.bk

  # Enforce bandwidth limits
  MAX_BANDWIDTH=$(nvram get usage_max) # Bytes

  if [ -z "${MAX_BANDWIDTH+x}" ]; then 
    echo "No bandwidth limits set" > /dev/null;
  else
    cat /jffs/traffic.bk | sed 's/{usage:://' | sed 's/;}//' | awk -v max=$MAX_BANDWIDTH '{ split($0, a, ";") } END { for(i in a) { split(a[i], usage, ":"); sum+=usage[2]; sum+=usage[3] }; { if (sum > max) { printf ". /tmp/Usage/scripts/disable_wan.sh" } } }' > /tmp/bandwidth_enforce.sh;
    . /tmp/bandwidth_enforce.sh;
    rm /tmp/bandwidth_enforce.sh;
  fi

  sleep 10
done