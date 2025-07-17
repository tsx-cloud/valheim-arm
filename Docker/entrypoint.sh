#!/bin/bash

SERVER=/root/valheim-server
PERSISTENT="/root/.config/unity3d/IronGate/Valheim"
SETTINGS="${PERSISTENT}/settings"

# Quick function to generate a timestamp
timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

shutdown () {
    echo ""
    echo "$(timestamp) INFO: Recieved SIGTERM, shutting down gracefully"
    kill -2 $valheim_pid
}

# Set our trap
trap 'shutdown' TERM

echo "Load extra Box64 and Fex-emu settings from emulators.rc"
source /load_emulators_env.sh
echo " "

/print_app_versions.sh

echo "Update"
export SteamAppId=892970
steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir ${SERVER} +login anonymous +app_update 896660 validate +quit

echo "Checking if BepInEx files need to be copied"
mkdir -p "${SERVER}"
if [ ! -d "${SERVER}/BepInEx" ]; then
    echo "Copy BepInEx files"
	cp -r defaults/server/. "${SERVER}/"
else
    echo "The folder ${SERVER}/BepInEx already exists, copying is not needed."
fi
echo " "

echo "Wine configuration"
winetricks sound=disabled

echo "Trying to remove /tmp/.X0-lock"
rm -f /tmp/.X0-lock
echo " "

echo "Starting Xvfb"
Xvfb :0 -screen 0 1024x768x16 &
sleep 5

echo "Starting server PRESS CTRL-C to exit"
echo " "
cd ${SERVER}

if [[ ! -f ${SERVER}/linux64/libpulse-mainloop-glib.so.0 ]]; then
    echo "Installing libpulse-mainloop-glib.so.0:x86_64"
    mkdir -p "${SERVER}/linux64/"
    pushd "$(mktemp -d)"
    wget http://mirrors.edge.kernel.org/ubuntu/pool/main/p/pulseaudio/libpulse-mainloop-glib0_17.0%2Bdfsg1-2ubuntu2_amd64.deb
    dpkg -x libpulse-mainloop-glib0_17.0+dfsg1-2ubuntu2_amd64.deb ./
    cp usr/lib/x86_64-linux-gnu/libpulse-mainloop-glib.so.0 "${SERVER}/linux64/"
    echo "Installing libpulse-mainloop-glib.so.0:x86_64 - Done"
    popd
fi

sed -i "s/^enabled *=.*/enabled = ${ENABLE_PLUGINS}/" "${SERVER}/doorstop_config.ini"
if [ "$ENABLE_PLUGINS" = "true" ]; then
    echo "Plugins support is ENABLED"
    export WINEDLLOVERRIDES="winhttp=n,b"
else
    echo "Plugins support is DISABLED"
fi

mkdir -p "${PERSISTENT}/logs"
LOG_FILE="${PERSISTENT}/logs/valheim_$(date '+%d-%m-%Y').log"

wine valheim_server.exe \
    -name "$SERVER_NAME" \
    -port 2456 \
    -world "$SERVER_WORLD" \
    -password "$SERVER_PASSWORD" \
    -public $SERVER_VISIBILITY \
    -saveinterval $SERVER_SAVE_INTERVAL \
    -backups $SERVER_BACKUPS \
    -backupshort $SERVER_BACKUP_SHORT \
    -backuplong $SERVER_BACKUP_LONG \
    -savedir ${PERSISTENT} \
    -crossplay \
    -nographics \
    -batchmode \
    2>&1 | tee -a ${LOG_FILE} &

# Find pid for valheim_server
timeout=0
while [ $timeout -lt 11 ]; do
    if ps -e | grep "valheim_server"; then
        valheim_pid=$(ps -e | grep "valheim_server" | awk '{print $1}')
        break
    elif [ $timeout -eq 10 ]; then
        echo "$(timestamp) ERROR: Timed out waiting for valheim_server.exe to be running"
        exit 1
    fi
    sleep 6
    ((timeout++))
    echo "$(timestamp) INFO: Waiting for valheim_server.exe to be running"
done

echo " "
echo "Checking NTSYNC"
echo "The NTSYNC module has been present in the Linux kernel since version 6.14 and is usually included only in the generic kernel versions."
echo "Kernel version on this machine is -- $(uname -r)"

echo " "
/usr/bin/lsof /dev/ntsync
echo " "
if /sbin/lsmod | grep -q ntsync; then
  if /usr/bin/lsof /dev/ntsync > /dev/null 2>&1; then
    echo "NTSYNC Module is present in kernel, ntsync is running."
  else
    echo "NTSYNC Module is present in kernel, but ntsync is NOT running. No problem — ntsync is not nessesary."
  fi
else
  echo "NTSYNC Module is NOT present in kernel. No problem — ntsync is not nessesary."
fi
echo " "

# Hold us open until we recieve a SIGTERM
wait

# Handle post SIGTERM from here
# Hold us open until WSServer-Linux pid closes, indicating full shutdown, then go home
tail --pid=$valheim_pid -f /dev/null

# o7
echo "$(timestamp) INFO: Shutdown complete."
exit 0
