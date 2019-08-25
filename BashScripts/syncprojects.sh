#!/bin/bash

# tidy!
clear

# Name of known projects
# 2nd level folders will be searched for these.
declare -A targetProjects=( 
	# full UIs
	["AzeriteUI"]="true" 
	["DiabolicUI"]="true" 
	["GoldieSix"]="true" 
	["LaeviaUI"]="true" 
	["WarcraftUI"]="true"
	#["KkthnxUI"]="true" 
	#["KkthnxUI_Config"]="true" 
	# standalones
	["Abacus"]="true" 
	["Abacus_Blizzard"]="true" 
	["Abacus_Stone"]="true" 
	["Backpacker"]="true" 
	["Blizzkill"]="true" 
	["Orbs"]="true" 
	["SimpleClassPower"]="true"
	# plugins
	["AzeriteUI_KuiNameplates"]="true" 
	#["Bagnon_BoE"]="true" 
	#["Bagnon_Garbage"]="true" 
	#["Bagnon_ItemInfo"]="true" 
	#["Bagnon_ItemLevel"]="true" 
	#["Bagnon_Uncollected"]="true" 
	#["Masque_ArcaneStone"]="true" 
	#["Masque_Azerite"]="true" 
	#["Masque_BrassCogs"]="true" 
	#["Masque_CrudeStone"]="true" 
	#["Masque_Diabolic"]="true" 
	#["Masque_Dragon"]="true" 
	#["Masque_Goldpaw"]="true" 
	#["Masque_KulTiras"]="true" 
	#["Masque_Proudmoore"]="true" 
	#["Masque_RoughBolts"]="true" 
	#["Masque_RoughCogs"]="true" 
	#["Masque_SpikyStone"]="true" 
)

declare -A targetProjectsClassic=( 
	["AzeriteUI_Classic"]="true" 
)

# where our source addon files are located
projectPath=~/'Documents/Development/WoWProjects'

# where our addons folders are located
wowAddons=~/'Games/World of Warcraft/_retail_/Interface/AddOns'
wowAddonsClassic=~/'Games/World of Warcraft/_classic_/Interface/AddOns'

# iterate through the project folder
for dir in "$projectPath"/*/
do
	
	# full path to the addon project directory
	projectDir=${dir%*/}
	projectParentName=${projectDir##*/}

	# iterate project directory for sub-directories
	for subDir in "$projectDir"/*/
	do

		# full path to the addon directory
		projectPath=${subDir%*/}

		# name of the addon directory
		projectName=${projectPath##*/}

		#echo "$projectParentName :: $projectName"

		# Retail
		if [ "${targetProjects["$projectName"]}" == "true" ]
		then

			# path to the destionation addon directory or symlink
			addonPath="$wowAddons/$projectName" 

			# does a file or symlink exist at the destionation?
			if [ -f "$addonPath" ] || [ -L "$addonPath" ] || [ -d "$addonPath" ]
			then 
				rm -rf "$addonPath"
			fi 

			# create the directory if it's missing
			if [ ! -d "$addonPath" ]
			then 
				mkdir "$addonPath"
			fi 

			# should always be true, but checking just 
			# in case something went wrong earlier. 
			if [ -d "$addonPath" ]
			then 
				rsync -r -u "$projectPath"/* "$addonPath" 
			fi 

			echo "......RETAIL: $projectName"

		fi 

		# Classic
		if [ "${targetProjectsClassic["$projectName"]}" == "true" ]
		then

			# path to the destionation addon directory or symlink
			addonPathClassic="$wowAddonsClassic/$projectName" 

			# does a file or symlink exist at the destionation?
			if [ -f "$addonPathClassic" ] || [ -L "$addonPathClassic" ] || [ -d "$addonPathClassic" ]
			then 
				rm -rf "$addonPathClassic"
			fi 

			# create the directory if it's missing
			if [ ! -d "$addonPathClassic" ]
			then 
				mkdir "$addonPathClassic"
			fi 

			# should always be true, but checking just 
			# in case something went wrong earlier. 
			if [ -d "$addonPathClassic" ]
			then 
				rsync -r -u "$projectPath"/* "$addonPathClassic" 
			fi 

			echo "......CLASSIC: $projectName"

		fi 
	done 
done 

#read -rp "Press Enter to exit!"
#clear
exit 0
