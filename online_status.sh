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
        wget -q --tries=10 --timeout=20 --spider http://google.com
        if [[ $? -eq 0 ]]; then
            echo "Conneted to homebase."
        else
            echo "Disconneted from homebase."
        fi
    fi
    sleep 10
done