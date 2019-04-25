#!/usr/bin/env python3
# This requires wmctrl xdotool

import subprocess
import sys
import time

subprocess.Popen(["/bin/bash", "-c", sys.argv[1]])
windowname = sys.argv[2]

def read_wlist(w_name):
	try:
		l = subprocess.check_output(["wmctrl", "-l"]).decode("utf-8").splitlines()
		return [w.split()[0] for w in l if w_name in w][0]
	except (IndexError, subprocess.CalledProcessError):
		return None

t = 0
while t < 30:
	window = read_wlist(windowname)
	time.sleep(0.1)
	if window != None:
		subprocess.Popen(["xdotool", "windowminimize", window])
		break
	time.sleep(1)
	t += 1
