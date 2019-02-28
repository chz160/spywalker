#!/bin/bash
. /etc/default/spywalker.conf
#wlanInterfaceName=${hcxdumpInterface}
read monInterfaceName <<< $(sudo ifconfig | awk 'match($1,"${hcxdumpInterface}mon") {print substr($1,RSTART,RLENGTH)}')
if [ -z "$monInterfaceName" ]
then
	echo "Killing troublesome processes..."
	sudo airmon-ng check kill
        echo "Creating monitor interface on ${hcxdumpInterface}..."
        sudo airmon-ng start ${hcxdumpInterface}
	read monInterfaceName <<< $(ifconfig | awk 'match($1,"${hcxdumpInterface}mon") {print substr($1,RSTART,RLENGTH)}')
else
        echo "Monitor interface already exists as: $monInterfaceName"
fi
# Get Wifis that are in range.
#sudo hcxdumptool -i $monInterfaceName -o capture.pcapng --enable_status=15 --use_gpsd
sudo hcxdumptool -i $monInterfaceName -o capture.pcapng --enable_status=15
