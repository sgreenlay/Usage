#!/bin/sh

cp -r /jffs/Usage /tmp/
find /tmp/Usage -name '*.sh' -type f | xargs chmod +x
ln -s /tmp/Usage/js/traffic.js /tmp/www/
. /tmp/Usage/tracker.sh
