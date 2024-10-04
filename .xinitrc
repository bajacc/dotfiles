#!/bin/sh

# xinitrc runs automatically when you run startx.

# There are some small but important commands that need to be run when we start
# the graphical environment. I keep those commands in ~/config/xprofile because
# that file is run automatically if someone uses a display manager (login
# screen) and so they are needed there. To prevent doubling up commands, I
# source them here with the line below.

[ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null

xcompmgr &		# xcompmgr for transparency
dunst & 		# dunst for notifications
xset r rate 300 50 &	# Speed xrate up (power management?)
unclutter &		# Remove mouse when idle
setbg & 		# set the background with the `setbg` script

# Comment/uncomment these lines depending on what wm you want to use. Also
# check the i3blocks line above.
dwm-run
# ssh-agent dwm
# ssh-agent xmonad
