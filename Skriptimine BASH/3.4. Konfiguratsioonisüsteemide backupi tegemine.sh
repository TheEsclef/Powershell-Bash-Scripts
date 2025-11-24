#!/bin/bash

sudo mount.cifs //DC1/Backup /mnt/DC1 -o username=Kardo.E,password=Terase5193!

if [ $? -ne 0 ]; then
    echo "Mount failed: insufficient permissions or wrong credentials"
    exit 13   # exit code 13 for permission denied
fi


while true
do
    cp /home/esclef/Desktop/test/* /mnt/DC1/it24/NimelisedBackupid/Kardo.E/
    if [ $? -ne 0 ]; then
        echo "Copy failed: insufficient permissions"
        exit 13
    fi
    sleep 350
done
