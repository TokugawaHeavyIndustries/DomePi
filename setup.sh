#!/bin/bash

apt update
apt install xvfb x11vnc supervisor fluxbox

##start install for build reqs
apt install git qtbase5-dev qt5-default qt5-qmake libqt5serialport5-dev libusb-1.0

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
