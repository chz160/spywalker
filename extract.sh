#!/bin/bash
dirName=$1
echo "Extract data from .pcapng file."
hcxpcaptool \
 -E $dirName/essid.txt \
 -I $dirName/identity_list.txt \
 -U $dirName/username_list.txt \
 -P $dirName/plainmasterkey_list.txt \
 -T $dirName/traffic_info.txt \
 -g $dirName/gps.txt \
 -z $dirName/pmkids.16800 \
 $dirName/capture.pcapng