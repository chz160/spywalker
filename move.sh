#!/bin/bash
. /etc/default/spywalker.conf
dirName=$1

# If no copy destination is set in the config file then end script early.
if test "$extractedFilesDestination" == ""; then
        exit 0
fi

echo "Checking for home base network..."
ssid=""
offline=true
#while [ "$offline" == true ] && [ "$ssid" != "$homeBaseSsid" ]; do
while [ "$offline" == true ]; do
	ssid=$(iwgetid -r)
        wget -q --tries=10 --timeout=20 --spider http://google.com
        if [[ $? -eq 0 ]]; then
                offline=false;
#        else
#                sleep 1
        fi
done

echo "Mounting network location..."
sudo mount -a
if test ! -d "$extractedFilesDestination"; then
        sudo mkdir $extractedFilesDestination        
fi
for d in walk_*
do
	echo "Moving $d..."
	sudo mv $d $extractedFilesDestination/$d
done
