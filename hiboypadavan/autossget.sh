#!/bin/sh
killall ssget.sh
killall -9 ssget.sh
sleep 2
wget --no-check-certificate -q https://raw.githubusercontent.com/nslook/padavanssidup/master/hiboypadavan/autohssget -O /tmp/ssget.sh;sh /tmp/ssget.sh 4

