#!/bin/bash

# tidy!
clear

# Name of the source project
# This will never be deleted. Again. /facepalm
sourceProject='AzeriteUI'

# Name of known target projects
# I need this when I accidentally delete 
# the libraries without adding them back in. 
declare -A targetProjects=( 
	["DiabolicOrbs"]="true" 
	["GoldieSix"]="true" 
	["SimpleClassPower"]="true"
)

# where our source addon files are located
projectPath=~/'Documents/Development/WoWProjects'

# where our libraries are located
libPath="$projectPath/$sourceProject/$sourceProject/back-end"

if [ ! -d "$libPath" ]
then
	echo "Source libraries are missing!"
	echo "Path: $libPath"
	echo " "
	read -rp "Press Enter to exit!"
	clear
	exit 0
fi 

# iterate through the project folder
for dir in "$projectPath"/*/
do
	
	# full path to the addon project directory
	projectDir=${dir%*/}

	# iterate project directory for sub-directories
	for subDir in "$projectDir"/*/
	do
		# full path to the addon project directory
		projectPath=${subDir%*/}

		# name of the addon project directory
		projectName=${projectPath##*/}

		# path to this addon's library folder
		backEnd="$projectPath/back-end"

		#echo "$backEnd"

		if [ -d "$backEnd" ] || [ "${targetProjects["$projectName"]}" == "true" ]
		then

			if [ "$backEnd" != "$libPath" ] && [ "$projectName" != "$sourceProject" ]
			then
				echo "...Updating CogWheel libraries in '$projectName'" 

				echo "......Clearing out the old"
				rm -rf "$backEnd"

				echo "......Copying over the new"
				cp -rf "$libPath" "$projectPath"

				echo " "
			fi 
		fi 
	done 
done 

read -rp "Press Enter to exit!"
clear
exit 0
