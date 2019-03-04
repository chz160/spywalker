#!/bin/bash
. /etc/default/spywalker.conf
echo "Checking for home base network..."
while true
do
    homeBaseSig=$( sudo iw $onboardInterface scan | egrep "SSID|signal" | egrep -B1 "$homeBaseSsid" | egrep -o "[0-9\.\-]+")
	activeSsid=$(iwgetid -r)
    echo "homeBaseSig: $homeBaseSig"
    echo "activeSsid: $activeSsid"
    if [ "$activeSsid" != "$homeBaseSsid" ] && [ "$homeBaseSig" != "" ] && (( $(echo "$homeBaseSig > 0"|bc -l) )); then
        ifdown --force $onboardInterface
        ifup $onboardInterface
        sleep 5
        activeSsid=$(iwgetid -r)
    fi
    wget -q --tries=10 --timeout=20 --spider http://google.com
    if [ $? -eq 0 ] && [ "$activeSsid" == "$homeBaseSsid" ]; then
        echo "Connected to homebase wifi."
    else
        echo "Disconnected from homebase wifi."
    fi
    sleep 10
done