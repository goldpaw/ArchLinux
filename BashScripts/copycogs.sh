#!/bin/bash

# tidy!
clear

# where our libraries are located
libPath=~/'Development/WoW Projects/AzeriteUI/AzeriteUI/back-end'

# where our source addon files are located
wowProjects=~/'Development/WoW Projects'

# iterate through the project folder
for dir in "$wowProjects"/*/								
do
	
	# full path to the addon project directory
	projectDir=${dir%*/}

	# iterate project directory for sub-directories
	for subDir in "$projectDir"/*/								
	do
		# full path to the addon project directory
		projectPath=${subDir%*/}

		# name of the addon project directory
		addonDir=${projectPath##*/}

		# path to this addon's library folder
		backEnd="$projectPath/back-end"

		#echo "$backEnd"

		if [ -d "$backEnd" ]
		then 

			if [ "$backEnd" != "$libPath" ]
			then
				echo "...Updating CogWheel libraries in '$addonDir'" 

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
exit 0
