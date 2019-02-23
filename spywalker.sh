#!/bin/bash
homeBaseSsid=$1
workingDir=$2
if test -f spywalker.conf ; then
	. spywalker.conf
fi
if [ homeBaseSsid == "" ]; then
	echo "homeBaseSsid has no value. This must be set as a parameter or in spywalker.conf." 1>&2
	exit 1
fi
session=walk
window=${session}:0
pane1=${window}.0
pane2=${window}.1
pane3=${window}.2
pane4=${window}.3
if [ workingDir != "" ]; then
	cd $workingDir
fi
tmux new -s walk -d \; \
	split-window -v \; \
	select-pane -t 0 \; \
	split-window -h \; \
	select-pane -t 2 \; \
	split-window -h \; \
	send-keys -t 0 "./control_loop.sh $homeBaseSsid" C-m \;
#tmux attach -t walk
