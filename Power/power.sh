#!/usr/bin/env bash

# Copyright (c) 2019, Carlos Millett

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


choice=$(echo -e -n "LOCK\nSLEEP\nLOGOUT\nREBOOT\nPOWEROFF\n" | rofi -dmenu -width 15 -lines 5)
case ${choice} in
    LOCK)
        {
            sleep 1 ;
            ${HOME}/.local/bin/lock.sh ${HOME}/.config/Xlock.png ;
        } &
        ;;
    SLEEP)
        {
            sleep 1 ;
            systemctl suspend ;
        } &
        ;;
    LOGOUT)
        bspc quit
        ;;
    REBOOT)
        {
            notify-send --app-name power.sh 'REBOOT' '' ;
            sleep 1 ;
            systemctl reboot ;
        } &
        ;;
    POWEROFF)
        {
            notify-send --app-name power.sh 'POWEROFF' '' ;
            sleep 1
            systemctl poweroff ;
        } &
        ;;
esac
