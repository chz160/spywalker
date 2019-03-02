#!/bin/bash
. /etc/default/spywalker.conf
#sudo iw phy `iw dev wlan0 info | gawk '/wiphy/ {printf "phy" $2}'` interface add ${kismetInterface}mon type monitor
#sudo ifconfig ${kismetInterface}mon up

# read monKismetInterface <<< $(sudo ifconfig | awk 'match($1,"${kismetInterface}mon") {print substr($1,RSTART,RLENGTH)}')
# if [ -z "$monKismetInterface" ]
# then
#     echo "Creating monitor interface on ${kismetInterface}..."
#     sudo airmon-ng start ${kismetInterface}
# 	read monKismetInterface <<< $(ifconfig | awk 'match($1,"${kismetInterface}mon") {print substr($1,RSTART,RLENGTH)}')
# else
#         echo "Monitor interface already exists as: $monKismetInterface"
# fi

#sudo airmon-ng start ${monKismetInterface}
sudo kismet -c ${kismetInterface}
  
