# DomePi

A Raspberry Pi image that features the Domesday Duplicator capture application via a web-accessible VNC client.

## About

This software aims to simplify the usage of the Domesday Duplicator capture application.  [Before reading any further, head on over to the Domesday86 website to read more about the project.](https://www.domesday86.com/?page_id=978).

As the DdD is high-bandwidth and requires USB3.0, this image is only supported on Raspberry Pi 4 boards.

This image contains the following software:
* Xvfb - X11 in a virtual framebuffer
* x11vnc - VNC server that scrapes the above X11 server
* noNVC - HTML5 canvas vnc viewer
* Fluxbox - Small window manager
* Supervisor - Process controller
* usbreset - Resets the usb bus on init
* DomesdayDuplicator - GUI front-end for the Domesday Duplicator project [repo](https://github.com/simoninns/DomesdayDuplicator)


## Installation

Download and flash the latest release, available [here](https://github.com/TokugawaHeavyIndustries/DomePi/releases/latest).

After installation, run `sudo ./post-install.sh` to configure the install.



It is highly recommended to use the flashable image, as it has been extensively tested. However, you may also install yourself using the provided setup script.  Note, this has only been tested on Raspberry Pi OS Lite, armhf.  Remember to run post install after.

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

## Notes

1) Default username/password is pi/raspberry.  You'll want to change this by logging in via ssh and using passwd.
2) If capturing to local storage, the SMB share is not password protected.
3) If capturing to local storage, the NFS share is valid for all connecting hosts.
4) If capturing to SMB storage, your username and password are stored in plain text in fstab.

All of the above will be mitigated in a future release.

## License
This image contains the Domesday Duplicator software from Simon Inns and is shared under the original software's license: [GPLv3](https://github.com/TokugawaHeavyIndustries/DomePi/blob/main/LICENSE)
