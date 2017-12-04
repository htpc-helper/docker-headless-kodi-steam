#!/bin/bash
### every exit != 0 fails the script
set -e

# Config variables
USER=htpc-helper
HOME="/home/$USER"
PASSWD_PATH="$HOME/.vnc/passwd"

## resolve_vnc_connection
VNC_IP=$(hostname -i)

## change vnc password
echo -e "\n------------------ change VNC password  ------------------"

if [[ $VNC_VIEW_ONLY == "true" ]]; then
    echo "start VNC server in VIEW ONLY mode!"
    #create random pw to prevent access
    echo $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20) | vncpasswd -f > $PASSWD_PATH
fi
echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH

# Change ownership of documents dir
chown -R "$USER:$USER" $HOME
chmod 600 $PASSWD_PATH

