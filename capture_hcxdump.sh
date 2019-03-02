#!/bin/bash
. /etc/default/spywalker.conf
#wlanInterfaceName=${hcxdumpInterface}
searchMonInterface="${hcxdumpInterface}mon"
echo "Searching for $searchMonInterface, if unavailable, setting it up..."
read monHcxInterface <<< $(sudo ifconfig | awk 'match($1,"$searchMonInterface") {print substr($1,RSTART,RLENGTH)}')
if [ -z "$monHcxInterface" ]
then
	echo "Killing troublesome processes..."
	sudo airmon-ng check kill
        echo "Creating monitor interface on $hcxdumpInterface..."
        sudo airmon-ng start $hcxdumpInterface
	read monHcxInterface <<< $(ifconfig | awk 'match($1,"$searchMonInterface") {print substr($1,RSTART,RLENGTH)}')
else
        echo "Monitor interface already exists as: $monHcxInterface"
fi
# Get Wifis that are in range.
#sudo hcxdumptool -i $monHcxInterface -o capture.pcapng --enable_status=15 --use_gpsd
sudo hcxdumptool -i $monHcxInterface -o capture.pcapng --enable_status=15
