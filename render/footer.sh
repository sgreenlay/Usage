#!/bin/sh
echo "  <div id=\"floatKiller\"></div>"
echo "   <div id=\"statusInfo\">"
echo "    <div class=\"info\"><script type=\"text/javascript\">Capture(share.firmware)</script>:"
echo "    <script type=\"text/javascript\">"
echo "    //<![CDATA["
echo "     document.write(\"<a title='" + share.about + "' href='javascript:openAboutWindow()'>$(cat /tmp/loginprompt|grep DD-WRT|cut -d' ' -f1) $(cat /tmp/loginprompt|grep DD-WRT|cut -d' ' -f2) ($(cat /tmp/loginprompt|grep Release|cut -d' ' -f2)) $(cat /tmp/loginprompt|grep DD-WRT|cut -d' ' -f3)</a>\");"
echo "    //]]>"
echo "    </script>"
echo "    </div>"
echo "   <div class=\"info\"><script type=\"text/javascript\">Capture(share.time)</script>:  <span id=\"uptime\"></span></div>"
echo "   <div class=\"info\">WAN<span id=\"ipinfo\">&nbsp;$(nvram get wan_ipaddr)</span></div>"
echo "  </div>"
echo " </div>"
echo " </div>"
echo " </body>"
echo "</html>"