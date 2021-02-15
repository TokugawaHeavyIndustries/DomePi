# DomePi

A Raspberry Pi image that features the Domesday Duplicator capture application via a web-accessible VNC client.

## About

This image contains the following:
* Xvfb - X11 in a virtual framebuffer
* x11vnc - VNC server that scrapes the above X11 server
* noNVC - HTML5 canvas vnc viewer
* Fluxbox - Small window manager
* Supervisor - Process controller
* usbreset - Resets the usb bus on init
* DomesdayDuplicator - GUI front-end for the Domesday Duplicator project


## Installation

Download and flash the latest release, available [here](https://github.com/TokugawaHeavyIndustries/DomePi/releases/latest).

It is highly recommended to use the flashable image, as it has been tested. However, you may also install yourself using the provided setup script.  Note, this has only been tested on Raspberry Pi OS Lite.

```
wget https://raw.githubusercontent.com/TokugawaHeavyIndustries/DomePi/main/setup.sh
chmod +x setup.sh
sudo ./setup.sh
```

## Usage

Simply navigate to your Pi's IP address via port 8080 to use.  For example:
```
http://192.168.1.199:8080
```

## License
[GPLv3](https://github.com/TokugawaHeavyIndustries/DomePi/blob/main/LICENSE)
