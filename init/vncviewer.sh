#!/bin/sh
cd $HOME
/sbin/setuser htpc-helper /usr/bin/vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION