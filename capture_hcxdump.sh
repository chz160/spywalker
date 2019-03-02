#!/bin/bash
. /etc/default/spywalker.conf
#wlanInterfaceName=${hcxdumpInterface}
read monHcxInterface <<< $(sudo ifconfig | awk 'match($1,"${hcxdumpInterface}mon") {print substr($1,RSTART,RLENGTH)}')
if [ -z "$monHcxInterface" ]
then
	echo "Killing troublesome processes..."
	sudo airmon-ng check kill
        echo "Creating monitor interface on ${hcxdumpInterface}..."
        sudo airmon-ng start ${hcxdumpInterface}
	read monHcxInterface <<< $(ifconfig | awk 'match($1,"${hcxdumpInterface}mon") {print substr($1,RSTART,RLENGTH)}')
else
        echo "Monitor interface already exists as: $monHcxInterface"
fi
# Get Wifis that are in range.
#sudo hcxdumptool -i $monHcxInterface -o capture.pcapng --enable_status=15 --use_gpsd
sudo hcxdumptool -i $monHcxInterface -o capture.pcapng --enable_status=15
