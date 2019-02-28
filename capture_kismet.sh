#!/bin/bash
. /etc/default/spywalker.conf
#sudo iw phy `iw dev wlan0 info | gawk '/wiphy/ {printf "phy" $2}'` interface add ${kismetInterface}mon type monitor
#sudo ifconfig ${kismetInterface}mon up

read monInterfaceName <<< $(sudo ifconfig | awk 'match($1,"${kismetInterface}mon") {print substr($1,RSTART,RLENGTH)}')
if [ -z "$monInterfaceName" ]
then
    echo "Creating monitor interface on ${kismetInterface}..."
    sudo airmon-ng start ${kismetInterface}
	read monInterfaceName <<< $(ifconfig | awk 'match($1,"${kismetInterface}mon") {print substr($1,RSTART,RLENGTH)}')
else
        echo "Monitor interface already exists as: $monInterfaceName"
fi

sudo airmon-ng start ${monInterfaceName}
sudo kismet -c ${monInterfaceName}
  
