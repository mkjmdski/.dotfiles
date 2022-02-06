#!/bin/bash -x
if [ -f "./script.sh" ]; then
    ./script.sh
    exit 0
fi

touch script.sh
chmod +x script.sh

if [ ! -s "./script.sh" ]; then
    echo "#!/bin/bash" > ./script.sh
fi
