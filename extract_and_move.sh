#!/bin/bash
dirName=$1
homeBaseSsid=$2
cd $dirName
echo "Extract PMKIDs from .pcap file."
hcxpcaptool \
 -E essid.txt \
 -I identity_list.txt \
 -U username_list.txt \
 -P plainmasterkey_list.txt \
 -T traffic_info.txt \
 -g gps.txt \
 -z pmkids.16800 \
 capture.pcapng
cd ..

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

#echo "Copy to crusher.junkhole.local to be cracked."
#scp local.16800 noah@192.168.1.8:/home/noah/local.16800

echo "Mounting network location..."
sudo mount -a
sudo mkdir /mnt/tank/walks/
for d in walk_*
do
	echo "Moving $d..."
	sudo mv /home/pi/$d /mnt/tank/walks/$d
done

