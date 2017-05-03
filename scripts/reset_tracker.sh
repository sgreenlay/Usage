#!/bin/sh

DATE=`date +%Y-%m-%d`

cp /jffs/traffic.bk "/jffs/traffic-$DATE.bk"
echo "{usage:: }" > /jffs/traffic.bk

reboot
