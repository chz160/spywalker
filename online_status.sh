#!/bin/bash
. /etc/default/spywalker.conf
echo "Checking for home base network..."
while true
do
	ssid=$(iw $onboardInterface link | grep ssid)
    if [ "$ssid" != "$homeBaseSsid" ]; then
        ifdown --force $onboardInterface
        ifup $onboardInterface
        sleep 5
        ssid=$(iw $onboardInterface link | grep ssid)
    fi
    wget -q --tries=10 --timeout=20 --spider http://google.com
    if [ $? -eq 0 ] && [ "$ssid" == "$homeBaseSsid" ]; then
        echo "Connected to homebase wifi."
    else
        echo "Disconnected from homebase wifi."
    fi
    sleep 10
done