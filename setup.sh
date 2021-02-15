#!/bin/bash

## add jessie repo for old x11vnc version
jessierepo="deb http://raspbian.raspberrypi.org/raspbian/ jessie main contrib non-free rpi"

if grep -Fxq "$jessierepo" "/etc/apt/sources.list" ;
then
        echo 'Repo already exists' ;
else
        echo "$jessierepo" | tee -a /etc/apt/sources.list ;
fi
apt update

## install virtual framebuffer, supervisor, and dwm
apt -y install xvfb supervisor fluxbox

## fix supervisor net issue
unlink /var/run/supervisor.sock

## install old x11vnc version with tearing fix
apt -y install libvncserver0=0.9.9+dfsg2-6.1+deb8u8 x11vnc=0.9.13-1.2 x11vnc-data=0.9.13-1.2

## bring down the novnc embed that doesnt suck
mkdir /root/novnc
cd /root/novnc
git clone https://github.com/TokugawaHeavyIndustries/DomePi.git
mv /root/novnc/DomePi/novnc/ /usr/share/novnc/
cd ..
rm -r -f ./novnc

##start install for build reqs
apt -y install git qtbase5-dev qt5-default qt5-qmake libqt5serialport5-dev libusb-1.0

##download and build usbreset
wget "https://raw.githubusercontent.com/TokugawaHeavyIndustries/DomePi/main/usbreset.c"
cc usbreset.c -o usbreset
chmod +x usbreset
mv usbreset /etc/
rm usbreset.c

##buld app
mkdir /etc/ddd
cd /etc/ddd
git clone https://github.com/simoninns/DomesdayDuplicator
cd ./DomesdayDuplicator/Linux-Application/DomesdayDuplicator
qmake
make all
make install

## download supervisor conf and copy to dir
wget https://raw.githubusercontent.com/TokugawaHeavyIndustries/DomePi/main/supervisord.conf
mv supervisord.conf /etc/supervisor/conf.d/supervisord.conf
