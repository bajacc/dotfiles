#!/bin/zsh

# zsh profile file. Runs on login. Environmental variables are set here.

. ~/.env

# Start graphical server on tty1 if not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pidof Xorg >/dev/null 2>&1  && exec startx

