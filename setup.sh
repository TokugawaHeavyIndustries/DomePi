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

## install git, virtual framebuffer, supervisor, and dwm
apt -y install xvfb supervisor fluxbox git

## fix supervisor net issue
unlink /var/run/supervisor.sock

## install old x11vnc version with tearing fix
apt -y install libvncserver0=0.9.9+dfsg2-6.1+deb8u8 x11vnc=0.9.13-1.2 x11vnc-data=0.9.13-1.2

## bring down the novnc embed that doesnt suck, build usbreset, move supervisor conf
mkdir /root/build
cd /root/build
git clone https://github.com/TokugawaHeavyIndustries/DomePi.git
mv /root/build/DomePi/novnc/ /usr/share/novnc/
cd /root/build/DomePi
cc usbreset.c -o usbreset
chmod +x usbreset
mv usbreset /etc/
mv supervisord.conf /etc/supervisor/conf.d/supervisord.conf
rm -r -f ./novnc

##start install for build reqs
apt -y install qtbase5-dev qt5-default qt5-qmake libqt5serialport5-dev libusb-1.0

##buld app
mkdir /etc/ddd
cd /etc/ddd
git clone https://github.com/simoninns/DomesdayDuplicator
cd ./DomesdayDuplicator/Linux-Application/DomesdayDuplicator
qmake
make all
make install
