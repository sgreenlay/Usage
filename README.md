Usage
====

Usage is a dd-wrt script (based on [ddwrt_conntrack](https://github.com/impressiver/ddwrt_conntrack)) that monitors per-client bandwidth usage and enforces limits.

# Setup
1. Clone or download the folder then run:
```
cd <download location>
scp -r [\!.]* root@<router ip>:/jffs/Usage
```
2. SSH into your router and run:
```
nvram set mypage_scripts="/tmp/Usage/render.sh"
nvram commit
```
3. Paste the contents of *startup.sh* into your router's start-up script
4. Reboot your router

# Configuration
To set bandwidth limits, SSH into your router and run:
```
nvram set usage_max="<usage limit in bytes>"
nvram commit
```

# Future work
- Reset bandwidth counter at the beginning of the month and re-enable WAN if it was disabled
- Enforce per-client bandwidth caps