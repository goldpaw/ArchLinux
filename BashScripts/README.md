# BashScripts
A collection of scripts I use to automate some tasks while developing addons and working with World of Warcraft on my personal Arch linux install. Not in any way tailored to fit anybody else but me, and only published here as my personal online backup. 

## copycogs.sh  
Copies my personal "CogWheel" library collection from my source project AzeriteUI to any other addon project that currently uses them. I've chosen not to symlink any library files do to the complications this would cause with Git. This script only works in my WoW Project folder. 

## killwine.sh  
A script I grabbed from somewhere I don't remember to properly kill all prosesses run by a particular wine prefix. Much more efficient than the built-in commands to do so. I'm using this to shut down any remnants after closing games or the battle.net client which always has tons left running. 

## makelinks.sh  
Scans my WoWProject folder for addons with toc files, and symlinks those addons to the WoW game addon folder. Will overwrite any existing links, folders or files found in the game directory, but don't do anything to the WoW project directory. 

## wacom.sh  
My little script to setup my dinosaur old Wacom Intuos GD-0912-R serial protocol 5 tablet. It retrieves the current monitor, screen size, tablet size and area and calculates a setup that gives me a correct aspect ratio when using it. Some values are hardcoded into this file, and like everything else here or related to my wacom drivers this is NOT suited for public consumption or releases.  

## worldofwarcraft.sh  
Run World of Warcraft, choose different wine installs based on what graphics API we choose to use, make sure prefixes are created or updated and so on. All my desktop launchers for World of Warcraft uses this script. 

### commands:  
* **--resetprefix**  
	Resets all the prefixes used for WoW.  
* **--resetcache**  
	Resets WoW's own cache. Sometimes useful on larger patches.  
* **--resetdxvk**  
	Resets the DirectX11 caches from dxvk and dxgi to avoid them growing out of proportion. No stritcly needed anymore as they have patched this upstream in dxvk.  
* **--d3d11**  
	Runs WoW in DirectX11 mode, using dxvk and its dxgi replacement. Mutually exclusive with --d3d12.  
* **--d3d12** (default)  
	Runs WoW in DirectX12 mode, using vkd3d. Mutually exclusive with --d3d11.  
* **--console**  
	Runs WoW in -console mode, to extract graphics assets and interface code. 

