#!/bin/bash

# tidy!
clear

# using lua to do math 
calc () { 
	lua -e "print($1)" 
}

# hardcoded device IDs (xsetwacom --list devices)
declare -A deviceIDs=( 
	["stylus"]="13" 
	["eraser"]="14" 
	["cursor"]="15"
)

# hardcoded device names (xsetwacom --list devices)
declare -A deviceNames=( 
	["stylus"]="Wacom protocol 5 serial tablet stylus"
	["eraser"]="Wacom protocol 5 serial tablet eraser"
	["cursor"]="Wacom protocol 5 serial tablet cursor"
)

# tablet area in mm. measured by hand. 
devicePhysicalWidth=310
devicePhysicalHeight=242
devicePhysicalAspect=$(calc "$devicePhysicalWidth/$devicePhysicalHeight")

# get the name of the connected primary monitor (source: https://wiki.archlinux.org/index.php/Xrandr)
monitor=$(xrandr | grep -E " connected (primary )?[1-9]+" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")

# get the resolution 
monitorResolution=( $(xrandr | fgrep '*') )
monitorWidth=$(echo $monitorResolution | sed -e "s/\([-0-9]\+\)x\([-0-9]\+\)/\1/")
monitorHeight=$(echo $monitorResolution | sed -e "s/\([-0-9]\+\)x\([-0-9]\+\)/\2/")
monitorAspect=$(calc "$monitorWidth/$monitorHeight")

multiplier=$(calc "$devicePhysicalAspect/$monitorAspect")

# Notes for my own noobish use. I'm new at this!
# 	"${deviceNames[@]}" expands the values 
# 	"${!deviceNames[@]}" (notice the !) expands the keys
for key in "${!deviceNames[@]}";
do
	deviceID=${deviceIDs[$key]}
	deviceName=${deviceNames[$key]}

	echo "Setting up $key (id:$deviceID):"

	echo "...Mapping output to $monitor"
	xsetwacom set "$deviceID" MapToOutput "$monitor" 		# map it to our monitor

	echo "...Resetting area"
	xsetwacom set "$deviceName" ResetArea 					# reset to its full area

	echo "...Setting mode to Absolute"
	xsetwacom set "$deviceName" Mode "Absolute" 			# set mode to Absolute

	# get the full area coordinates
	deviceArea=($(xsetwacom get "$deviceName" Area)) 

	# assign it to separate variables for readability
	leftX=${deviceArea[0]}
	topY=${deviceArea[1]}
	rightX=${deviceArea[2]}
	bottomY=${deviceArea[3]}

	tabletWidth=$(calc "$rightX-$leftX")
	tabletHeight=$(calc "$bottomY-$topY")

	# we blatently assume the monitor has  
	# a larger aspect ratio than the tablet. 
	tabletTargetHeight=$(calc "math.floor($tabletHeight*$multiplier)")

	x1=0
	x2=$tabletWidth
	y1=$(calc "math.floor(($tabletHeight-$tabletTargetHeight)/2)")
	y2=$(calc "$tabletHeight-$y1")

	echo "...Mapping Area to: $x1 $y1 $x2 $y2"
	xsetwacom set "$deviceName" Area "$x1" "$y1" "$x2" "$y2"

done 

echo "All done! Goodbye!"

sleep 3
exit 0
