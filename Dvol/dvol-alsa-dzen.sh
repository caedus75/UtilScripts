#!/bin/bash

#
# Original code by: bruening ( https://bbs.archlinux.org/viewtopic.php?id=46608 )
# Modified by: caedus75
#

#Customize this stuff
IF="Master"
SECS="3"

FONT="terminus-9"
BG="#$(getXresColor background)"
FG="#$(getXresColor foreground)"
XPOS="542"
YPOS="300"
WIDTH="196"

#Probably do not customize
PIPE="/tmp/dvolpipe"

err() {
  echo "${1}"
  exit 1
}

usage() {
  echo "usage: dvol [option] [argument]"
  echo
  echo "Options:"
  echo "     -i, --increase - increase volume by 'argument'"
  echo "     -d, --decrease - decrease volume by 'argument'"
  echo "     -t, --toggle   - toggle mute on and off"
  echo "     -h, --help     - display this"
  exit
}

#Argument Parsing
case "${1}" in
  '-i'|'--increase')
    [ -z "${2}" ] && err "No argument specified for increase."
    AMIXARG="${2}%+"
    ;;
  '-d'|'--decrease')
    [ -z "${2}" ] && err "No argument specified for decrease."
    AMIXARG="${2}%-"
    ;;
  '-t'|'--toggle')
    AMIXARG="toggle"
    ;;
  ''|'-h'|'--help')
    usage
    ;;
  *)
    err "Unrecognized option '$1', see dvol --help"
    ;;
esac

#Actual volume changing (readability low)
AMIXOUT="$(amixer set "${IF}" "${AMIXARG}" | tail -n 1)"
MUTE="$(cut -d '[' -f 4 <<< "${AMIXOUT}")"
if [ "${MUTE}" = "off]" ]; then
  VOL="0"
else
  VOL="$(cut -d '[' -f 2 <<< "${AMIXOUT}" | sed 's/%.*//g')"
fi

#Using named pipe to determine whether previous call still exists
#Also prevents multiple volume bar instances
if [ ! -e "${PIPE}" ]; then
    mkfifo "${PIPE}"
    ( dzen2\
        -l 1\
        -fg "${FG}"\
        -bg "${BG}"\
        -x "${XPOS}"\
        -y "${YPOS}"\
        -w "${WIDTH}"\
        -fn "${FONT}"\
        -e 'onstart=uncollapse'\
        < "${PIPE}"
    rm -f "${PIPE}" ) &
fi

#Feed the pipe!
( echo "Volume" ; echo "${VOL}" | dbar ; sleep "${SECS}" ) > "${PIPE}"
