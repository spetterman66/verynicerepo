#!/bin/bash
if pgrep -x "xmr" > /dev/null
then
    echo "it's running!"
else
    echo "it's not running!"
fi
