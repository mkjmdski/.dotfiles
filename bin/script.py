#!/bin/bash -x
if [ -f "./script.py" ]; then
    if [ -f requirements.txt ]; then
        if [ ! -d venv ]; then
            python3 -m venv venv
            source venv/bin/activate
            pip3 install -r requirements.txt
        fi
    fi
    ./script.py
    exit 0
fi

touch script.py
chmod +x script.py

if [ ! -s "./script.py" ]; then
    echo "#!/usr/bin/env python3" > ./script.py
fi
