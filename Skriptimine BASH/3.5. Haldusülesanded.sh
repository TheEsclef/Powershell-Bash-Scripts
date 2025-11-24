#!/bin/bash

#Vaatab kas monitor.txt eksisteerib
if [ ! -f monitor.txt ]; then
    touch monitor.txt
else
    echo "Monitor.txt eksisteerib, ei muuda midagi"
fi

while true
do
    # CPU Kasutus
    cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
    # Memory Kasutus
    mem=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
    # Diski Kasutus
    disk=$(df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}')


    # Kirjutab info .txt faili, enne teeb selle tühjaks
    echo "" > monitor.txt
    echo "CPU Usage: $cpu%" >> monitor.txt
    echo "Memory Usage: $mem%" >> monitor.txt
    echo "Disk Useage: $disk%" >> monitor.txt

    sleep 60 #Ootab minut aega, enne kui uuesti teeb
done
