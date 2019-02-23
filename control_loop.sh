#!/bin/bash
homeBaseSsid=$1
extractedFilesDestination=$2
dirName=""
keeplooping=true
homeBaseInRange=true
leavingHomeBase=false
arrivingAtHomeBase=false
homeBaseSigThreshold=-30
while [ keeplooping ]
do
	echo "Collecting data..."
	read homeBaseSig <<< $( sudo iw wlan0 scan | egrep 'SSID|signal' | egrep -B1 'jackstack' | awk 'match($2,"[0-9\-]+") {print substr($2,RSTART,RLENGTH)}')
	if [ "$homeBaseSig" -ge "$homeBaseSigThreshold" ]; then
		if [ "$homeBaseInRange" == false  ]; then
			arrivingAtHomeBase=true;
		else
			arrivingAtHomeBase=false;
		fi
		leavingHomeBase=false
		homeBaseInRange=true
	else
		if [ "$homeBaseInRange" == true  ]; then
			leavingHomeBase=true;
                else
                        leavingHomeBase=false;
                fi
		arrivingAtHomeBase=false;
		homeBaseInRange=false
	fi
	echo "--------------------------------------------------"
	echo "homeBaseSig: $homeBaseSig dB"
	echo "homeBaseInRange: $homeBaseInRange"
	echo "leavingHomeBase: $leavingHomeBase"
	echo "arrivingAtHomeBase: $arrivingAtHomeBase"
	echo "--------------------------------------------------"
	if [ "$homeBaseInRange" == false ] && [ "$leavingHomeBase" == true ]; then
		echo "TODO: turn off bluetooth radio."
		echo "Starting capture..."
		dirName=walk_$(date +%Y%m%d%H%M%S)
		tmux send-keys -t walk.1 "./capture_hcxdump.sh $dirName" C-m
		tmux send-keys -t walk.2 "./capture_kismet.sh $dirName" C-m
	fi
	if [ "$homeBaseInRange" == true ] && [ "$arrivingAtHomeBase" == true ]; then
		echo "TODO: Turn on bluetooth radio."
		echo "Stopping capture..."
		tmux send-keys -t walk.1 C-c
		tmux send-keys -t walk.2 C-c
		echo "Extract data from .pcapng file and move to network."
		tmux send-keys -t walk.3 "./extract_and_move.sh $dirName $homeBaseSsid $extractedFilesDestination" C-m
	fi
	sleep 30
done
echo All done
