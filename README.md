# jedi_remote
A quick 'hack' to issue media controls over a local network from a phone to a mac

## Background
I hate paying for software I think I can write ; I hate it when people try to 
change good money for stupid things. One day I got really tired of reaching over and changing the volume on the mac while watching something on a streaming service. What I really need was a remote. Apple should have made this posible, Netflix should have made this posible, anyone should have made this posible. But no, there only seams to exist really shady programs on the web requiring you to run a server on your mac doing who knows what to your computer. -- I figured I could do no worse with a couple of lines of bash code so here you go.

## Overview
Jedi Remote consists of a simple web page hosted by a mac. The mac in question 
is the one you want to control.

* [src](src)
    * [log_remote.sh](src/log_remote.sh) - processor ; run on mac
    * [site](src/site)
        * [index.html](src/site/index.html) - User Interface ; load on phone
        * [scripts](src/site/scripts) - JavaScript
        * [styles](src/site/styles) - CSS

The `log_remote.sh` script will listen to the Apache access logs looking for 
requests. These request are made when buttons in the `index.html`. All requests
are for files which don't exist, but that is not the point. By just making the
request Apache will log the action in the access file as a 404 (file not found).
This is enough to for the script to find, and when it does it will issue 
AppleScript commands to change volume or your current track.

## Design requirements
* Assume Apache is running
* require as little as posible in setup
* really small footprint
* assume you own your network

## Design Notes

### Apache commands

* /action/volume?RemoteCommand-volume-up
* /action/volume?RemoteCommand-volume-down
* /action/track?RemoteCommand-track-next
* /action/track?RemoteCommand-track-pre
* /action/track?RemoteCommand-track-playpause

Example script:

The following apple script will set the volume 5 "steps" above the current value.

`set volume output volume ((output volume of (get volume settings)) + 5)`