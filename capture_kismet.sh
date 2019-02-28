#!/bin/bash
. /etc/default/spywalker.conf
sudo iw phy `iw dev wlan0 info | gawk '/wiphy/ {printf "phy" $2}'` interface add ${kismetInterface}mon type monitor
sudo ifconfig ${kismetInterface}mon up
sudo kismet -c ${kismetInterface}mon
  
