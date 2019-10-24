#!/bin/bash

# tidy!
clear

# where our source addon files are located
projectPath=~/'Documents/Development/WoWProjects'

# Retail paths
sourceProject='AzeriteUI'
libPath="$projectPath/$sourceProject/$sourceProject/back-end"
declare -A targetProjects=( 
	# full UIs
	["GoldieSix"]="true" 
	["LaeviaUI"]="true" 
	# standalones
	["Abacus"]="true" 
	["Backpacker"]="true" 
	["Blizzkill"]="true" 
	["Orbs"]="true" 
	["SimpleClassPower"]="true"
	# plugins
	["AzeriteUI_KuiNameplates"]="true"
)

# Classic paths
sourceProjectClassic='AzeriteUI_Classic'
libPathClassic="$projectPath/$sourceProjectClassic/$sourceProjectClassic/back-end"
declare -A targetProjectsClassic=( 
	["ClassicUnitFramesEnhanced"]="true" 
	["ClassicQuestTrackerEnhanced"]="true"
)

# Make sure our source paths are valid
if [ ! -d "$libPath" ] || [ ! -d "$libPathClassic" ]
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

		# copy to Retail projects
		if [ -d "$backEnd" ] || [ "${targetProjects["$projectName"]}" == "true" ]
		then

			if [ "$backEnd" != "$libPath" ] && [ "$backEnd" != "$libPathClassic" ] && [ "$projectName" != "$sourceProject" ] && [ "$projectName" != "$sourceProjectClassic" ]
			then
				echo "...Updating libraries in '$projectName'" 
				rm -rf "$backEnd"
				cp -rf "$libPath" "$projectPath"
			fi 
		fi 

		# copy to classic projects
		if [ -d "$backEnd" ] || [ "${targetProjectsClassic["$projectName"]}" == "true" ]
		then

			if [ "$backEnd" != "$libPath" ] && [ "$backEnd" != "$libPathClassic" ] && [ "$projectName" != "$sourceProject" ] && [ "$projectName" != "$sourceProjectClassic" ]
			then
				echo "...Updating libraries in '$projectName'" 
				rm -rf "$backEnd"
				cp -rf "$libPath" "$projectPath"
			fi 
		fi 

	done 
done 

#read -rp "Press Enter to exit!"
#clear
exit 0
