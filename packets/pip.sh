#!/bin/bash
if ! python3 --version; then
    echo "Install python and come back" && exit 1
fi
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
rm get-pip.py
pip3 install -r requirements.txt