#!/bin/bash
. /etc/default/spywalker.conf
searchMonInterface="${hcxdumpInterface}mon"
echo "Searching for $searchMonInterface, if unavailable, setting it up..."
#read monHcxInterface <<< $(sudo ifconfig | awk 'match($1,"${searchMonInterface}") {print substr($1,RSTART,RLENGTH)}')
read monHcxInterface <<< $(sudo ifconfig | egrep -o "$searchMonInterface")
if [ -z "$monHcxInterface" ]; then
	echo "Creating monitor interface on $hcxdumpInterface..."
	sudo airmon-ng start $hcxdumpInterface
	read monHcxInterface <<< $(sudo ifconfig | egrep -o "$searchMonInterface")
	if [ -z "$monHcxInterface" ]; then
		echo "$searchMonInterface was not found." 1>&2
		exit 1
	fi
else
        echo "Monitor interface already exists as: $monHcxInterface"
fi

# Get Wifis that are in range.
echo "Starting dump on $searchMonInterface...   ;-D"
sudo hcxdumptool -i $searchMonInterface -o capture.pcapng --enable_status=15
