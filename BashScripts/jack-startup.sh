#!/bin/bash
for i in {10..1..-1}
do 
	clear
	echo "Starting jack in $i seconds"
	sleep 1
done
jack_control start & 
exit 0
