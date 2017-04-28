#!/bin/sh

WAN_IFNAME=$(nvram get wan_ifname)
ifconfig $WAN_IFNAME down