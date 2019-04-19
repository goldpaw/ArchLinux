#!/bin/bash

# generic stuff, 
# will be filled in later
_args=''
_argsExist=false
_resetPrefix=false
_resetWoWCache=false
_resetDXVKCache=false
_useD3D12=true
_useD3D11=false
_useConsoleMode=false

# these paths will be populated based on settings
wine=''
wineboot=''
winePrefix=''
winePrefixFolder=''

# wine folder paths
winePathStagingPlain=/opt/'wine-tkg-git-staging-plain-4.6.r3.g36e84f29'/bin
winePathD3D11=/opt/'wine-tkg-git-dxvk-4.6.r3.g36e84f29'/bin
winePathD3D12=/opt/'wine-tkg-git-vkd3d-4.6.r3.g36e84f29'/bin

# wine prefix folders
WoW_D3D11='WoW_D3D11'
WoW_D3D12='WoW_D3D12'

# wine prefix paths
winePrefixOld="$winePrefix" # old path, we're not using this anymore
winePrefixD3D11=~/"Games/WinePrefixes/$WoW_D3D11"
winePrefixD3D12=~/"Games/WinePrefixes/$WoW_D3D12"

# wow game path
wowPath=~/'Games/World of Warcraft'

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
	--d3d11)
		_useD3D11=true
		_useD3D12=false
		;;
	--d3d12)
		_useD3D11=false
		_useD3D12=true
		;;
	--console)
		_useConsoleMode=true
		;;
	*)
		;;
	esac
done

# do any prefixes forcefully need to be reset?
_resetPrefixD3D11=false
_resetPrefixD3D12=false

if [[ "$_resetPrefix" == true ]]
then 
	#reset both prefixes if the argument is passed
	_resetPrefixD3D11=true
	_resetPrefixD3D12=true

else
	# reset prefixes that don't exist yet
	if [ ! -d "$winePrefixD3D11" ]
	then
		_resetPrefixD3D11=true
	fi

	if [ ! -d "$winePrefixD3D12" ]
	then
		_resetPrefixD3D12=true
	fi
fi

# remove the old prefix if it's still there
if [ -d "$winePrefixOld" ]
then 
	echo "...Removing the old deprecated Wine Prefix."
	rm -rf "$winePrefixOld"
fi 

if [[ "$_resetPrefixD3D11" == true ]] 
then 
	echo "...Resetting the DirectX11 Prefix."

	# remove the prefix if it's there
	if [ -d "$winePrefixD3D11" ]
	then 
		echo "......Removing the old DirectX11 Wine Prefix."
		rm -r --force "$winePrefixD3D11"
	fi 

	# create the new prefix, set it up 
	echo "......Initializing the DirectX11 Wine Prefix."
	env WINEPREFIX="$winePrefixD3D11" WINEDEBUG=-all WINEARCH='win64' "$winePathD3D11"/wineboot >/dev/null

	echo "......Setting the Windows version to Windows10."
	env WINEPREFIX="$winePrefixD3D11" WINEDEBUG=-all winetricks -q win10 >/dev/null

	echo "......Enabling better font smoothing."
	env WINEPREFIX="$winePrefixD3D11" WINEDEBUG=-all winetricks -q fontsmooth=rgb >/dev/null
fi

if [[ "$_resetPrefixD3D12" == true ]] 
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

# decide what wine version to run
# and what launch arguments to use.
if [[ "$_useD3D12" == true ]] 
then 
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
else 
	echo "...Running WoW with DirectX11 > Vulkan support." 
	wine="$winePathD3D11"/wine
	wineboot="$winePathD3D11"/wineboot
	winePrefix="$winePrefixD3D11"
	winePrefixFolder="$WoW_D3D11"
	if [[ "$_argsExist" == true ]] 
	then 
		_args="$_args -d3d11"
	else
		_args="-d3d11"
		_argsExist=true
	fi 
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

# fully kill the prefix upon exiting 
echo "...Killing any remnants of the Wine Prefix"
./killwine.sh -9 "$winePrefixFolder"

echo " " # get some air in here
echo "Done! Goodbye!"

# wait for user input?
#read -rp "Press Enter to exit!"

# now we're ready to leave
sleep 3
exit 0
