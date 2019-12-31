#!/bin/bash
#
# Created by OldPa Sink | JSCS Cardano Stake Pool
#
# List all the slots in the leaders logs, sorted by date/time and numbered.
#
# Disclaimer:
#
#  The following shell script is derived from stackexchange and google searches
#  and is for demonstration and understanding only, it should *NOT* be used at scale or for any sort of serious
#  deployment, and is solely used for learning how the node and blockchain works, and how to interact with everything.

clear

./jcli.exe rest v0 leaders logs get -h http://127.0.0.1:3101/api | grep scheduled_at_date | \
         awk '{print $NF}' | xargs -L 1 > logstemp1.txt
epoch="$(./jcli.exe rest v0 leaders logs get -h http://127.0.0.1:3101/api | grep scheduled_at_date | \
         awk '{print $NF}' | xargs -L 1 | sort | tail -n 1 |cut -f 1 -d '.')"
./jcli.exe rest v0 leaders logs get -h http://127.0.0.1:3101/api | grep scheduled_at_time | \
         awk '{print $NF}' | xargs -L 1 |while read p; do date -d $p +"%D %T"; done > logstemp2.txt
echo "  Epoch.Slot   Date      Time" > "leadersched${epoch}.txt"
paste -d " " logstemp1.txt logstemp2.txt | sort -k1 -k2 | cat -n | column -t >> "leadersched${epoch}.txt"
rm logstemp1.txt logstemp2.txt
cat "leadersched${epoch}.txt"
exit 0
