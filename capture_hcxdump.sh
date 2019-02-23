#!/bin/bash
#read wlanInterfaceName <<< $(sudo airmon-ng | awk 'match($2,"wlan[0-9]") {print substr($2,RSTART,RLENGTH)}')
#read monInterfaceName <<< $(sudo airmon-ng | awk 'match($2,"[a-z0-9]+mon") {print substr($2,RSTART,RLENGTH)}')
wlanInterfaceName=wlan1
read monInterfaceName <<< $(sudo ifconfig | awk 'match($1,"wlan1mon") {print substr($1,RSTART,RLENGTH)}')
if [ -z "$monInterfaceName" ]
then
	echo "Killing troublesome processes..."
	sudo airmon-ng check kill
        echo "Creating monitor interface on $wlanInterfaceName..."
        sudo airmon-ng start $wlanInterfaceName
	read monInterfaceName <<< $(ifconfig | awk 'match($1,"wlan1mon") {print substr($1,RSTART,RLENGTH)}')
else
        echo "Monitor interface already exists as: $monInterfaceName"
fi

dirName=$1
if [ "$dirName" == "" ]; then
	dirName=walk_$(date +%Y%m%d%H%M%S)
fi
fileName=capture.pcapng
cd /home/pi
mkdir $dirName
cd $dirName

# Get Wifis that are in range.
#sudo hcxdumptool -i $monInterfaceName -o $fileName --enable_status=15 --use_gpsd
sudo hcxdumptool -i $monInterfaceName -o $fileName --enable_status=15
