#!/bin/bash
. /etc/default/spywalker.conf
. common.sh
echo "Checking for home base network..."
while true
do
    homeBaseSig=$( sudo iw $onboardInterface scan | egrep "SSID|signal" | egrep -B1 "$homeBaseSsid" | egrep -o "\-[0-9\.]+" | head -1)
    put homeBaseSig "$homeBaseSig"
	activeSsid=$(iwgetid -r)
    put activeSsid "$activeSsid"
    echo "homeBaseSig: $homeBaseSig"
    echo "activeSsid: $activeSsid"
    if [ "$activeSsid" != "$homeBaseSsid" ] && [ "$homeBaseSig" != "" ] && (( $(echo "$homeBaseSig > -70"|bc -l) )); then
        # We cant do this iface up/down shit because 
        # it will cause the code that monitors the
        # homebase signal strength in the control loop
        # to fail. This might not be able to be a loop. 
        # It might just need to be a script that is 
        # from the main control loop if the homeBaseSsid
        # is in range and we are not connected to it.
        
        #ifdown --force $onboardInterface
        #ifup $onboardInterface

        sudo ip link set $onboardInterface down
        sudo ip link set $onboardInterface up
        sudo wpa_supplicant -B -$onboardInterface -c /etc/wpa_supplicant/wpa_supplicant.conf -Dnl80211,wext
        sudo dhclient $onboardInterface
        
        # or maybe...
        # wpa_supplicant -B -i $onboardInterface -c <(wpa_passphrase "Your_SSID" Your_passphrase) && dhclient $onboardInterface

        # or maybe...
        # nmcli d wifi connect $homeBaseSsid password Your_Psswd_here iface $onboardInterface

        # or maybe but probably not...
        # wpa_cli \; \
        #     scan \; \
        #     scan_results \; \
        #     add_network \; \
        #     set_network 0 ssid "SSID_here" \; \
        #     set_network 0 psk "Passphrase_here" \;

        sleep 5s
        activeSsid=$(iwgetid -r)
        put activeSsid "$activeSsid"
    fi
    wget -q --tries=10 --timeout=20 --spider https://duckduckgo.com
    if [ $? -eq 0 ] && [ "$activeSsid" == "$homeBaseSsid" ]; then
        echo "Connected to homebase wifi."
        put offline "false"
    else
        echo "Disconnected from homebase wifi."
        put offline "true"
    fi
    sleep 10s
done