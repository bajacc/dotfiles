#!/bin/bash
# Open an Alacritty window with a random dark background and opacity.
set -eu

c() { printf '%02x' $(( RANDOM % 4 * 8 )); }
color="#$(c)$(c)$(c)"
opacity="0.$(( 70 + RANDOM % 16 ))"

exec open -na Alacritty --args \
  -o "colors.primary.background=\"$color\"" \
  -o "window.opacity=$opacity" "$@"
