#!/bin/bash

# tidy!
clear

# where our source addon files are located
wowProjects=~/'Documents/Development/WoWProjects'

# where our addons folder is located
wowAddons=~/'Games/World of Warcraft/_retail_/Interface/AddOns'

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

		# full path to the addon toc file
		tocFile="$projectPath/$addonDir.toc"

		# check if the folder has a sub-folder with the same name, 
		# and if an addon toc file exists within that folder. 
		if [ -f "$tocFile" ]
		then 

			# path to the destionation addon directory or symlink
			addonPath="$wowAddons/$addonDir" 

			# does a directory, file or symlink exist at the destionation?
			if [ -d "$addonPath" ] || [ -f "$addonPath" ] || [ -L "$addonPath" ]
			then 
				rm -rf "$addonPath"
			fi 

			# create the symbolic link
			ln -s "$projectPath" "$addonPath"

			echo "Symlinking $addonDir"
		fi 

	done

done

read -rp "Press Enter to exit!"
exit 0

