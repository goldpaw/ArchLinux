#!/bin/bash

# generic stuff, 
# will be filled in later
_args=''
_argsExist=false
_resetPrefix=false
_resetPrefix11=false
_resetPrefix12=false
_resetWoWCache=false
_resetDXVKCache=false
_useConsoleMode=false

# these paths will be populated based on settings
wine=''
wineboot=''
winePrefix=''
winePrefixFolder=''

# direct x12
winePathD3D12=/opt/'wine-tkg-git-worldofwarcraft-4.12.1.r5.g1b15ab1b'/bin

# wine prefix folders
WoW_D3D12='WoW_D3D12'

# wine prefix paths
winePrefixD3D12=~/"Games/WinePrefixes/$WoW_D3D12"

# wow game path
wowPath=~/'Games/World of Warcraft'

# dvxk path
dxvkPath='/run/media/lars/work/PackageBuilds/dxvk-tools/DXVKBUILD/master/7cb385facdfdda7881674dbfc8adb49a1aa35a10-2019-07-13-21:57:45'

# iterate through arguments
while [ $# -ne 0 ]
do
	ARG="$1"
	shift # get rid of $1, we saved in ARG already
	case "$ARG" in
	--resetprefix)
		_resetPrefix=true
		;;
	--resetcache)
		_resetWoWCache=true
		;;
	--resetdxvk)
		_resetDXVKCache=true
		;;
	--console)
		_useConsoleMode=true
		;;
	*)
		;;
	esac
done

if [ ! -d "$winePrefixD3D12" ]
then
	_resetPrefix=true
fi

if [[ "$_resetPrefix" == true ]] 
then 
	echo "...Resetting the DirectX12 Prefix."

	# remove the prefix if it's there
	if [ -d "$winePrefixD3D12" ]
	then 
		echo "......Removing the old DirectX12 Wine Prefix."
		rm -r --force "$winePrefixD3D12"
	fi 

	# create the new prefix, set it up 
	echo "......Initializing the DirectX12 Wine Prefix."
	env WINEPREFIX="$winePrefixD3D12" WINEDEBUG=-all WINEARCH='win64' "$winePathD3D12"/wineboot >/dev/null

	echo "......Setting the Windows version to Windows10."
	env WINEPREFIX="$winePrefixD3D12" WINEDEBUG=-all winetricks -q win10 >/dev/null

	echo "......Enabling better font smoothing."
	env WINEPREFIX="$winePrefixD3D12" WINEDEBUG=-all winetricks -q fontsmooth=rgb >/dev/null

	echo "......Setting up DXVK."
	env WINEPREFIX="$winePrefixD3D12" "$dxvkPath"/setup_dxvk.sh install --without-dxgi 
	
fi

if [[ "$_resetWoWCache" == true ]] 
then 
	echo "...Resetting the WoW cache."	

	# kill the wow cache files
	rm -r --force "$wowPath"/'_retail_/Cache'
fi 

if [[ "$_resetDXVKCache" == true ]] 
then 
	echo "...Resetting the DXVK cache."	

	# kill the dxvk cache files
	# *not needed from DXVK 1.0.3+
	rm -r --force "$wowPath"/'_retail_/Wow.dxvk-cache'
fi 

# move to the game path
cd "$wowPath"
echo "...Running WoW with DirectX12 > Vulkan support." 
wine="$winePathD3D12"/wine
wineboot="$winePathD3D12"/wineboot
winePrefix="$winePrefixD3D12"
winePrefixFolder="$WoW_D3D12"
if [[ "$_argsExist" == true ]] 
then 
	_args="$_args -d3d12"
else
	_args="-d3d12"
	_argsExist=true
fi 

# decide wow launch arguments
if [[ "$_useConsoleMode" == true ]] 
then 
	echo "...Running WoW in Console Mode"
	if [[ "$_argsExist" == true ]] 
	then 
		_args="$_args -console"
	else
		_args="-console"
		_argsExist=true
	fi 
fi

# add some args we always want there
_defaultArgs="-windowed -maximized -1920x1080 -uid wow_engb"

# run the game
if [[ "$_argsExist" == true ]] 
then 
	env WINEPREFIX="$winePrefix" WINEDEBUG=-all WINEESYNC=1 "$wine" ./_retail_/'Wow.exe' "$_args $_defaultArgs"
else
	env WINEPREFIX="$winePrefix" WINEDEBUG=-all WINEESYNC=1 "$wine" ./_retail_/'Wow.exe' "$_defaultArgs"
fi 

# return to our script folder

# fully kill the prefix upon exiting 
echo "...Killing any remnants of the Wine Prefix"
#~/'Documents/Development/ArchLinux/BashScripts/killwine.sh -9 "$winePrefixFolder"
env WINEPREFIX="$winePrefix" WINEDEBUG=-all wineserver -k9

echo " " # get some air in here
echo "Done! Goodbye!"

# wait for user input?
#read -rp "Press Enter to exit!"

# now we're ready to leave
sleep 3
exit 0
