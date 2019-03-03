#!/bin/bash
confDir="/etc/default/spywalker.conf"
if test -f ${confDir} ; then
	. ${confDir}
else
	echo "$confDir could not be found. Please make sure it exists and you update it with your configuration." 1>&2
	exit 1
fi
if [ "$homeBaseSsid" == "" ]; then
	echo "homeBaseSsid has no value. This must be set in $confDir." 1>&2
	exit 1
fi
if [ "$workingDir" == "" ]; then
	echo "workingDir has no value. This must be set in $confDir." 1>&2
	exit 1
fi
if [ "$onboardInterface" == "" ]; then
	echo "onboardInterface has no value. This must be set in $confDir." 1>&2
	exit 1
fi
if [ "$hcxdumpInterface" == "" ]; then
	echo "hcxdumpInterface has no value. This must be set in $confDir." 1>&2
	exit 1
fi
if [ "$kismetInterface" == "" ]; then
	echo "onboardInterface has no value. This must be set in $confDir." 1>&2
	exit 1
fi
if [ "$onboardInterface" == "$hcxdumpInterface" ] ||
   [ "$onboardInterface" == "$kismetInterface" ] ||
   [ "$hcxdumpInterface" == "$kismetInterface" ]; then
	echo "For spywalker to work correctly you must have 3 seperate wireless interfaces, and they must be configured in $confDir. onboardInterface, hcxdumpInterface, and kismetInterface must all be different interfaces." 1>&2
	exit 1
fi
session=walk
window=${session}:0
pane1=${window}.0
pane2=${window}.1
pane3=${window}.2
pane4=${window}.3
pane5=${window}.4
cd $workingDir
tmux new -s walk -d \; \
	split-window -v \; \
	select-pane -t 0 \; \
	split-window -h \; \
	select-pane -t 2 \; \
	split-window -h \; \
	split-window -v \; \
	send-keys -t 3 "./online_status.sh" C-m \; \
	send-keys -t 0 "./control_loop.sh" C-m \; \
	select-pane -t 4 \;
#tmux attach -t walk