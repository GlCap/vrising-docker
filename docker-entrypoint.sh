#!/bin/bash

set -eu

xvfb_wine() {
  sleep 1 && xvfb-run -e /dev/stdout -s "-screen 0 1024x768x16 -nolisten tcp -nolisten unix" wine "$@" || true
}

mkdir -p /home/vrising/.wine/drive_c/VRisingData/Settings
if [ -f settings/ServerGameSettings.json ]; then
  echo "Installing ServerGameSettings..."
  cp settings/ServerGameSettings.json /home/vrising/.wine/drive_c/VRisingData/Settings/ServerGameSettings.json
fi
if [ -f settings/ServerHostSettings.json ]; then
  echo "Installing ServerHostSettings..."
  cp settings/ServerHostSettings.json /home/vrising/.wine/drive_c/VRisingData/Settings/ServerHostSettings.json
fi

echo "Starting SteamCMD to install/update game..."

xvfb_wine steamcmd.exe +force_install_dir 'C:\VRisingServer' +login anonymous +app_update 1829350 validate +quit

sleep 1

echo "Starting game..."

xvfb_wine VRisingServer.exe -persistentDataPath 'C:\VRisingData'
