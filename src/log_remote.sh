#!/bin/bash

# Run this script on the Macintosh OS X computer that you wish to control.
# Apple Script must be allowed to interact with your computer

STEP=5
LOG=/private/var/log/apache2/access_log
VERBOSE='false'

# Print out a help message
function help
{
    printf "Look for and act on requests from the apache activity log\n\n"
    format="%4s %-10s | %-7s %-25s | %s\n"
    printf "${format}" "Flag"   Parameter   Name    Description Current
    printf "${format}" "----"   ----------  ------- -------------------------   -------
    printf "${format}" -l       "<path>"    log     "path to apache access log" ${LOG}
    printf "${format}" -s       "<number>"  step    "number of volume steps"    ${STEP}
    printf "${format}" -v       ""          verbose "show details"              ${VERBOSE}
    printf "${format}" -h       ""          help    "this output"
}

# verbose print - only print if in verbose mode, first parameter is the printf
# format, all other parameters are variables to printf
function v
{
    if [ "${VERBOSE}" == "true" ] ; then
        printf "$1\n" ${@:2:99}
    fi
}

# do the work of this script ; watch access log for volume and track commands
function main
{
    v "Listening for events from '%s'." $LOG
    while read line ; do
        case "$line" in
            *"RemoteCommand-volume-up"* )
                v "Volume Up"
                osascript -e \
                    "set volume output volume ((output volume of (get volume settings)) + ${STEP})"
                ;;
            *"RemoteCommand-volume-down"* )
                v "Volume Down"
                osascript -e \
                    "set volume output volume ((output volume of (get volume settings)) - ${STEP})"
                ;;
            # -e takes multi line strings
            *"RemoteCommand-track-pre"* )
                v "Previous Track"
                osascript -e '
                    tell application "iTunes"
                        previous track
                    end tell'
                ;;
            *"RemoteCommand-track-next"* )
                v "Next Track"
                osascript <<END-OSA
                    tell application "iTunes"
                        next track
                    end tell
END-OSA
                ;;
            # can also use input like so
            *"RemoteCommand-track-playpause"* )
                v "Play/pause"
                osascript <<END
                    tell application "iTunes"
                        playpause
                    end tell
END
                ;;
            * )
                printf "unknown:%s\n" $line
                ;;
        esac
    done < <(tail -n 0 -f ${LOG})
}

# process command line flags
while getopts "l:s:vh" opt; do
    case $opt in
        l)  LOG="${OPTARG}" ;;
        s)  STEP="${OPTARG}" ;;
        v)  VERBOSE='true' ;;
        h) help ; exit ;;
    esac
done

main
