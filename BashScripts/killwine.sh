#!/bin/bash

# killwine                       # Just kill all instances of wine
# killwine -9                    # Hard kill them all
# killwine lotro                 # Only kill wine under ~/'Games/WinePrefixes'/lotro
# killwine -INT lotro            # Same as above, but use SIGINT
# WINEPREFIX=/tmp/crap killwine  # Kill only the instance under /tmp/crap
# sudo reboot                    # Pretend you're running windows.

wine_cellar=~/'Games/WinePrefixes'

if (($#)); then
    if [[ -e "${wine_cellar}/$1" ]]; then
        WINEPREFIX="${wine_cellar}/$1"
        shift
    elif [[ "${1:0:1}" != "-" ]]; then
        echo "ERROR: Didn't understand argument '$1'?" >&2;
        exit 1
    fi
fi

if ((${#WINEPREFIX})); then
    pids=$(
        grep -l "WINEPREFIX=${WINEPREFIX}$" $(
            ls -l /proc/*/exe 2>/dev/null |
            grep -E 'wine(64)?-preloader|wineserver' |
            perl -pe 's;^.*/proc/(\d+)/exe.*$;/proc/$1/environ;g;'
        ) 2> /dev/null |
        perl -pe 's;^/proc/(\d+)/environ.*$;$1;g;'
    )
else
    pids=$(
        ls -l /proc/*/exe 2>/dev/null |
        grep -E 'wine(64)?-preloader|wineserver' |
        perl -pe 's;^.*/proc/(\d+)/exe.*$;$1;g;'
    )
fi

if ((${#pids})); then
    set -x
    kill $* $pids
fi

