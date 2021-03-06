#!/bin/bash

XFILE="$HOME/.Xresources"

COLS="$(cat $XFILE| grep -Ei \*color[01-9] | sort -n -tr -k2 | cut -d: -f2 | tr -d [:blank:])"

for i in {0..7}; do echo -en "\e[0;3${i}m ▉▉ $(echo "$COLS" | sed -n $(($i+1))'p')\e[0m"; done; echo
for i in {0..7}; do echo -en "\e[0;9${i}m ▉▉ $(echo "$COLS" | sed -n $(($i+9))'p')\e[0m"; done; echo -e "\n"
