#!/bin/bash

# tidy!
clear

# Name of known projects
# 2nd level folders will be searched for these.
declare -A targetProjects=( 
	["AzeriteUI"]="true" 
	["Bagnon_BoE"]="true" 
	["Bagnon_Garbage"]="true" 
	["Bagnon_ItemInfo"]="true" 
	["Bagnon_ItemLevel"]="true" 
	["Bagnon_Uncollected"]="true" 
	["DiabolicOrbs"]="true" 
	["DiabolicUI"]="true" 
	["GoldieSix"]="true" 
	["GoldpawUI"]="true" 
	["KkthnxUI"]="true" 
	["KkthnxUI_Config"]="true" 
	["Kui_Nameplates_AzeriteUI"]="true" 
	["Masque_ArcaneStone"]="true" 
	["Masque_Azerite"]="true" 
	["Masque_BrassCogs"]="true" 
	["Masque_CrudeStone"]="true" 
	["Masque_Diabolic"]="true" 
	["Masque_Dragon"]="true" 
	["Masque_Goldpaw"]="true" 
	["Masque_KulTiras"]="true" 
	["Masque_Proudmoore"]="true" 
	["Masque_RoughBolts"]="true" 
	["Masque_RoughCogs"]="true" 
	["Masque_SpikyStone"]="true" 
	["SimpleClassPower"]="true"
	["WarcraftUI"]="true"
)

# where our source addon files are located
projectPath=~/'Documents/Development/WoWProjects'

# where our addons folder is located
wowAddons=~/'Games/World of Warcraft/_retail_/Interface/AddOns'

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

		if [ "${targetProjects["$projectName"]}" == "true" ] && [ $projectParentName != "AzeriteUI_Classic" ]
		then

			echo ""

			# path to the destionation addon directory or symlink
			addonPath="$wowAddons/$projectName" 

			# does a file or symlink exist at the destionation?
			if [ -f "$addonPath" ] || [ -L "$addonPath" ] || [ -d "$addonPath" ]
			then 
				echo "......Clearing out the old: $projectName"
				rm -rf "$addonPath"
			fi 

			# create the directory if it's missing
			if [ ! -d "$addonPath" ]
			then 
				echo "......Creating directory: $projectName"
				mkdir "$addonPath"
			fi 

			# should always be true, but checking just 
			# in case something went wrong earlier. 
			if [ -d "$addonPath" ]
			then 
				echo "......Syncing $projectName"
				rsync -r -u "$projectPath"/* "$addonPath" 
			fi 

		fi 
	done 
done 

read -rp "Press Enter to exit!"
#clear
exit 0
