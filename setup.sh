#!/bin/bash

## Update hostname

NEW_NAME="domepi"
echo $NEW_NAME > /etc/hostname
sed -i "s/raspberrypi/$NEW_NAME/g" /etc/hosts
hostname $NEW_NAME

## install PowerShell mainly because I love PowerShell and I wrote the post install script in it

if ! command -v pwsh &> /dev/null
then
    wget https://github.com/PowerShell/PowerShell/releases/download/v7.1.2/powershell-7.1.2-linux-arm32.tar.gz
    mkdir /etc/powershell-7.1.2
    tar -xvf ./powershell-7.1.2-linux-arm32.tar.gz -C /etc/powershell-7.1.2/
    ln -s /etc/powershell-7.1.2/pwsh /usr/bin/pwsh
fi

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
apt -y install qtbase5-dev qt5-default qt5-qmake libqt5serialport5-dev libusb-1.0-0-dev

##buld app
mkdir /etc/ddd
cd /etc/ddd
git clone https://github.com/simoninns/DomesdayDuplicator
cd ./DomesdayDuplicator/Linux-Application/DomesdayDuplicator
qmake
make all
make install

##copy post install to home dir
cd /home/pi
wget https://raw.githubusercontent.com/TokugawaHeavyIndustries/DomePi/main/post-install.sh
chmod +x ./post-install.sh

cd /etc
wget https://raw.githubusercontent.com/TokugawaHeavyIndustries/DomePi/main/ledblink.sh
chmod +x ./ledblink.sh
echo "@reboot root /bin/sh /etc/ledblink.sh" > /home/pi/ledblink
mv /home/pi/ledblink /etc/cron.d/ledblink
chown root /etc/cron.d/ledblink
