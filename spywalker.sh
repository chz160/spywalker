#!/bin/bash
sysconfdir="/etc"
homeBaseSsid=$1
workingDir=$2
if test -f ${sysconfdir}/default/spywalker.conf ; then
	. ${sysconfdir}/default/spywalker.conf
fi
if [ "$homeBaseSsid" == "" ]; then
	echo "homeBaseSsid has no value. This must be set as a parameter or in ${sysconfdir}/default/spywalker.conf." 1>&2
	exit 1
fi
if [ "$workingDir" == "" ]; then
	workingDir="$PWD"
fi
session=walk
window=${session}:0
pane1=${window}.0
pane2=${window}.1
pane3=${window}.2
pane4=${window}.3
cd $workingDir
tmux new -s walk -d \; \
	split-window -v \; \
	select-pane -t 0 \; \
	split-window -h \; \
	select-pane -t 2 \; \
	split-window -h \; \
	send-keys -t 0 "./control_loop.sh $homeBaseSsid" C-m \;
#tmux attach -t walk
