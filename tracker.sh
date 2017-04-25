#!/bin/sh

# Bandwidth Download/Upload Rate Counter
LAN_TYPE=$(nvram get lan_ipaddr | awk ' { FS="."; print $1"."$2 }')

while :
do
  #Create the RRDIPT CHAIN (it doesn't matter if it already exists).
  iptables -N RRDIPT 2> /dev/null

  #Add the RRDIPT CHAIN to the FORWARD chain (if non existing).
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
    # Add iptable rules (if non existing).
    iptables -nL RRDIPT | grep "${IP}[[:space:]]" > /dev/null
    if [ $? -ne 0 ]; then
      iptables -I RRDIPT -d ${IP} -j RETURN
      iptables -I RRDIPT -s ${IP} -j RETURN
    fi
  done

  echo "{usage::" >> /tmp/traffic.dat
  iptables -L RRDIPT -vnx -t filter | grep ${LAN_TYPE} | awk '{ if ($8 == "0.0.0.0/0") { download[$9]=$2 } else if ($9 == "0.0.0.0/0") upload[$8]=$2 } END { for(item in upload) printf "%s:%.2f:%.2f;", item, upload[item]/1048576, download[item]/1048576}' >> /tmp/traffic.dat
  echo "}" >> /tmp/traffic.dat

  mv -f /tmp/traffic.dat /tmp/www/traffic.asp

  sleep 10
done