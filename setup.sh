#!/bin/bash

apt update
apt install xvfb supervisor fluxbox
unlink /var/run/supervisor.sock

sudo apt-get install libvncserver0=0.9.9+dfsg2-6.1+deb8u8 x11vnc=0.9.13-1.2 x11vnc-data=0.9.13-1.2

##start install for build reqs
apt install git qtbase5-dev qt5-default qt5-qmake libqt5serialport5-dev libusb-1.0

##download and build usbreset

cc usbreset.c -o usbreset
chmod +x usbreset
mv usbreset /etc/

##buld app
mkdir /root/ddd
cd /root/ddd
git clone https://github.com/simoninns/DomesdayDuplicator
cd ./DomesdayDuplicator/Linux-Application/DomesdayDuplicator
qmake
make all
make install

#remove build dir
cd ~
rm -r -f /root/ddd
