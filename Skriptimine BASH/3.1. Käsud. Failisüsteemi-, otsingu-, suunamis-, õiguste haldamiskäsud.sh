#!/bin/bash

#Loob vajaduse korral IT-KURSUS kausta
if [ ! -d "/home/public/Desktop/IT-KURSUS" ]; then
    mkdir "/home/public/Desktop/IT-KURSUS"
    echo "Kaust IT-KURSUS loodi edukalt"
fi

#Loob vajaduse korral IT23 kausta
if [ ! -d "/home/public/Desktop/IT-KURSUS/IT23" ]; then
    mkdir "/home/public/Desktop/IT-KURSUS/IT23"
    echo "Kaust IT23 loodi edukalt"
fi

#Loob vajaduse korral IT24 kausta
if [ ! -d "/home/public/Desktop/IT-KURSUS/IT24" ]; then
    mkdir "/home/public/Desktop/IT-KURSUS/IT24"
    echo "Kaust IT24 loodi edukalt"
fi

#loob teksti faili ja sisu
tekst="$RANDOM.txt"
echo "$RANDOM" > "/home/public/Desktop/IT-KURSUS/IT23/$tekst"

# IT-KURSUS kausta õigused
sudo chown :IT23 /home/public/Desktop/IT-KURSUS
sudo chown :IT24 /home/public/Desktop/IT-KURSUS
sudo chmod 770 /home/public/Desktop/IT-KURSUS
sudo setfacl -m g:IT23:rwx /home/public/Desktop/IT-KURSUS
sudo setfacl -m g:IT24:rwx /home/public/Desktop/IT-KURSUS

# IT23 kaust: ainult IT23 grupile
sudo setfacl -m g:IT23:rwx /home/public/Desktop/IT-KURSUS/IT23
sudo setfacl -m g:IT24:r /home/public/Desktop/IT-KURSUS/IT23

# IT24 kaust: ainult IT24 grupile
sudo setfacl -m g:IT24:rwx /home/public/Desktop/IT-KURSUS/IT24
sudo setfacl -m g:IT23:r /home/public/Desktop/IT-KURSUS/IT24
