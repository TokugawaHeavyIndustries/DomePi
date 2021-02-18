#!/usr/bin/pwsh

function setstatic {

$writeip = "N"

do {

    Clear-Host
    Write-Host "NETWORK SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Enter IP address in slash notation."
    Write-Host "For example: 192.168.199.55/24"
    Write-Host ""
    $ipcidr = Read-Host

    Clear-Host
    Write-Host "NETWORK SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Enter the gateway address."
    Write-Host "For example: 192.168.199.1"
    Write-Host ""
    $ipgate = Read-Host

    Clear-Host
    Write-Host "NETWORK SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Enter your DNS server address.  If multiple, seperate with spaces."
    Write-Host "For example: 1.1.1.1 8.8.8.8"
    Write-Host ""
    $ipdns = Read-Host

    Clear-Host
    Write-Host "NETWORK SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Does this look correct?"
    Write-Host ""
    Write-Host "IP Address: " $ipcidr
    Write-Host "Gateway: " $ipgate
    Write-Host "DNS Server(s): " $ipdns
    Write-Host ""
    Write-host "Write changes? If you're connected via SSH you'll need"
    Write-Host "need to reconnect and restart setup (obviously skipping"
    $writeip = Read-Host -Prompt "through the network setup you've already done). (Y/N)"

    } while ( $writeip -eq "n")
    
    if ($writeip -eq "y") {
    
        mv /etc/dhcpcd.conf /etc/dhcpcd.conf.bak

        echo "interface eth0" > /etc/dhcpcd.conf
        $dhcpcdl1 = "static ip_address="+$ipcidr
        echo $dhcpcdl1 >> /etc/dhcpcd.conf
        $dhcpdcl2 = "static routers="+$ipgate
        echo $dhcpdcl2 >> /etc/dhcpcd.conf
        $dhcpcdl3 = "static domain_name_servers="+$ipdns
        echo $dhcpcdl3 >> /etc/dhcpcd.conf

    } else {}
}

function changehostname {

$hostnameapply = "n"

do {

Clear-Host
Write-Host "NETWORK SETUP"
Write-Host ""
Write-Host ""
Write-Host "Enter new hostname:"
Write-Host ""
$newhostname = Read-Host

Clear-Host
Write-Host "NETWORK SETUP"
Write-Host ""
Write-Host ""
Write-Host "Does this look correct?"
Write-Host ""
Write-Host "Hostname: " $newhostname
Write-Host ""
$hostnameapply = Read-Host -Prompt "Apply changes?  They'll take effect at next reboot. (Y/N)"


} while ($hostnameapply = "n")

if ($hostnameapply = "y") {

    #hostname file change
    mv /etc/hostname /etc/hostname.bak
    echo $newhostname > /etc/hostname

    #hosts file change
    $hostfilel1 = "127.0.0.1`tlocalhost"
    $hostfilel2 = "127.0.0.1`t`t" + $newhostname
    
    mv /etc/hosts /etc/hosts.bak
    
    echo $hostfilel1 > /etc/hosts
    echo $hostfilel2 >> /etc/hosts

    }

    else {}

}

function serialsetup {

$usbserialconnected = ls /dev/tty* | grep "usb"

if ($usbserialconnected -eq $NULL) {
    Clear-Host
    Write-Host "SERIAL SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "There is currently not a USB serial adapter"
    Write-Host "attached.  Rerun setup to configure later."
    Write-Host ""
    pause
}
else {
    Clear-Host
    Write-Host "SERIAL SETUP"
    Write-Host ""
    Write-Host ""

    Write-Host "Your serial adapter is:" $usbserialconnected "  ............  [x]" 
    
    usermod -a -G dialout pi

    Write-Host "User `'pi`' added to dialout group  ........................  [x]" 

    $confserline = "serialDevice=" + $usbserialconnected.Trim("/dev/")
    $DDDConfig = "/.config/DomesdayDuplicator.ini"
    (Get-Content $DDDConfig) -replace "serialDevice=", $confserline | Set-Content $DDDConfig

    Write-Host "App preferences set  .......................................  [x]"

    Write-Host ""
    }
}

Clear-Host
Write-Host "**********************************"
Write-Host "** Thanks for installing DomePi **"
Write-Host "**                              **"
Write-Host "**   This setup will help you   **"
Write-Host "**   configure DomePi for the   **"
Write-Host "**  first time. You can always  **"
Write-Host "**  re-run this script to make  **"
Write-Host "**   changes to your install.   **"
Write-Host "**********************************"
Pause

$currentip = hostname -I

Clear-Host
Write-Host "NETWORK SETUP"
Write-Host ""
Write-Host ""
Write-Host "Current IP:" $currentip
Write-Host ""
Write-Host "Would you like to set a static IP?"
$staticip = Read-Host -Prompt 'Y/(N)'

if ($staticip -eq "y"){
    
    setstatic

}

else {}

$currenthostname = hostname

Clear-Host
Write-Host "NETWORK SETUP"
Write-Host ""
Write-Host ""
Write-Host "Current hostname:" $currenthostname
Write-Host ""
Write-Host "Would you like to change the hostname?"
$changehostname = Read-Host -Prompt 'Y/(N)?'

if ($changehostname -eq "y"){

    changehostname

}

else {}

Clear-Host
Write-Host "SERIAL SETUP"
Write-Host ""
Write-Host ""
Write-Host "If you have a USB serial adapter connected,"
Write-Host "DomePi can configure it to communicate with"
Write-Host "the Domesday Duplicator capture application"
Write-Host "and allow controlling your Laserdisc player."
Write-Host ""
$configserial = Read-Host -Prompt "Want to set up serial connectivity? Y/(N)"

if ($configserial -eq "Y") {

serialsetup

}

else {}


echo "cont"
