#!/bin/bash

# tidy!
clear

# our unsorted file
inputFile=~/Documents/'list'
outputFile=~/Documents/'list-sorted'
lineID=1

# associative array
# comment as the key, the code as the value
declare -A contents

# indexed array
# comment section as the value
declare -a comments

# copy our file line by line into an array
while read line; do

	# split the line into code and comment
	code=$(echo $line | grep -Po "^\K(.+) -- ")
	comment=$(echo $line | grep -Po " -- \K(.+)$")

	# associative array
	# comment as the key, the code as the value
	contents[$comment]=$code

	# indexed array
	# comment section as the value
	comments[$lineID]=$comment

	# increase the line counter
	lineID=$((lineID+1))

	clear; 
	echo "Reading line $lineID";

done < $inputFile

# sort the comment array
clear
echo "Sorting array..."; 
IFS=$'\n' sorted=($(sort <<<"${comments[*]}")); unset IFS

# create an output file with the sorted results
echo "-- Spell casts. Storing spellID to retrieve spell icon later on. " > $outputFile
for comment in "${sorted[@]}"
do
	echo ${contents[$comment]}$comment >> $outputFile
done

# done!
exit 0
