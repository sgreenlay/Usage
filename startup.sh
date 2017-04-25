#!/bin/sh

cp -r /jffs/Usage /tmp/

find /tmp/Usage -name '*.sh' -type f | xargs chmod +x
ln -s /tmp/Usage/js/traffic.js /tmp/www/

sleep 30

. /tmp/Usage/traffic.sh
