#!/bin/bash

## add jessie repo for old x11vnc version
echo "deb http://raspbian.raspberrypi.org/raspbian/ jessie main contrib non-free rpi" | tee -a /etc/apt/sources.list
apt update

## install virtual framebuffer, supervisor, novnc, and dwm
apt install xvfb supervisor fluxbox novnc

## fix supervisor net issue
unlink /var/run/supervisor.sock

## install old x11vnc version with tearing fix
sudo apt install libvncserver0=0.9.9+dfsg2-6.1+deb8u8 x11vnc=0.9.13-1.2 x11vnc-data=0.9.13-1.2

##start install for build reqs
apt install git qtbase5-dev qt5-default qt5-qmake libqt5serialport5-dev libusb-1.0

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

## download supervisor conf
wget https://raw.githubusercontent.com/TokugawaHeavyIndustries/DomePi/main/supervisord.conf
mv supervisord.conf /etc/supervisor/conf.d/supervisord.conf
