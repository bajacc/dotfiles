#!/bin/sh

# xinitrc runs automatically when you run startx.

[ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null

xcompmgr &		# xcompmgr for transparency
dunst & 		# dunst for notifications
xset r rate 200 100	# Speed xrate up
unclutter &		# Remove mouse when idle
setbg & 		# set the background with the `setbg` script

ssh-agent dwm-run
