#!/bin/bash
. /etc/default/spywalker.conf
#homeBaseSsid=$1
#workingDir=$2
#extractedFilesDestination=$3
dirName=""
keeplooping=true
homeBaseInRange=true
leavingHomeBase=false
arrivingAtHomeBase=false
homeBaseSigThreshold=-30
while [ keeplooping ]
do
	echo "Collecting data..."
	read homeBaseSig <<< $( sudo iw ${kismetInterface} scan | egrep "SSID|signal" | egrep -B1 "$homeBaseSsid" | awk 'match($2,"[0-9\-]+") { print substr($2,RSTART,RLENGTH)}')
	if [ "$homeBaseSig" != "" ] && [ "$homeBaseSig" -ge "$homeBaseSigThreshold" ]; then
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
#		"TODO: turn off bluetooth radio."
		echo "Starting capture..."
		dirName=walk_$(date +%Y%m%d%H%M%S)
		mkdir $dirName
		tmux send-keys -t walk.1 "cd $workingDir/$dirName; ../capture_hcxdump.sh" C-m
		tmux send-keys -t walk.2 "cd $workingDir/$dirName; ../capture_kismet.sh" C-m
	fi
	if [ "$homeBaseInRange" == true ] && [ "$arrivingAtHomeBase" == true ]; then
#		"TODO: Turn on bluetooth radio."
		echo "Stopping capture..."
		tmux send-keys -t walk.1 C-c
		tmux send-keys -t walk.2 C-c
		echo "Extract data from .pcapng file."
		tmux send-keys -t walk.3 "cd $workingDir" C-m
		tmux send-keys -t walk.3 "./extract.sh $dirName" C-m
		echo "Moving data to network location."
		tmux send-keys -t walk.3 "cd $workingDir" C-m
		tmux send-keys -t walk.3 "./move.sh $dirName" C-m
	fi
	sleep 30
done
echo All done
