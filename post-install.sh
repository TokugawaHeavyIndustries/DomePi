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

$usbserialconnected = ls /dev/tty* | grep "USB"

do {
    do {
    $usbserialconnected = ls /dev/tty* | grep "USB"
    if ($usbserialconnected -eq $NULL) {
        $usbserialname = "NONE"
    } else {
        $usbserialname = $usbserialconnected
    }

    Clear-Host
    Write-Host "SERIAL SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Detected device: $usbserialname"
    Write-Host ""
    $serialrescan = "Y"
    $serialrescan = Read-Host -Prompt "Would you like to rescan? (Y)/N"

    } while ($serialrescan -eq "Y")

    if ($serialrescan -eq "n" -and $usbserialconnected -eq $NULL) {
        Clear-Host
        Write-Host "SERIAL SETUP"
        Write-Host ""
        Write-Host ""
        Write-Host "Serial setup cancelled."
        Pause
        Break
    }

} while ($usbserialconnected -eq $NULL)

if ($usbserialconnected -ne $NULL) {
    Clear-Host
    Write-Host "SERIAL SETUP"
    Write-Host ""
    Write-Host ""

    Write-Host "Your serial adapter is:" $usbserialconnected "  .....................  [x]" 
    
    usermod -a -G dialout pi

    Write-Host "User `'pi`' added to dialout group  ..........................  [x]" 

    $confserline = "serialDevice=" + $usbserialconnected.Trim("/dev/")
    $DDDConfig = "/.config/DomesdayDuplicator.ini"
    (Get-Content $DDDConfig) -replace "serialDevice=", $confserline | Set-Content $DDDConfig

    Write-Host "App preferences set  .......................................  [x]"

    Write-Host ""
    }
}

function cifsclientsetup {

    $cifsinstalled = apt-cache policy cifs-utils | grep 'none'
    if ($cifsinstalled -ne $NULL) {
        apt install cifs-utils
    }

    $cifsok = "N"

do {

    Clear-Host
    Write-Host "CIFS SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Enter the complete server and share path."
    Write-Host "For example: //192.168.11.19/Data/DDDCaps"
    Write-Host ""
    $cifsserverpath = Read-Host

    Clear-Host
    Write-Host "CIFS SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Enter the username."
    Write-Host ""
    $cifsusername = Read-Host

    Clear-Host
    Write-Host "CIFS SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Enter the password."
    Write-Host ""
    $cifspass = Read-Host

    Clear-Host
    Write-Host "CIFS SETUP"
    Write-Host ""
    Write-Host ""

    if (Test-Path /mnt/dddcifs) {}
    else {
    mkdir /mnt/dddcifs }

    if (mount | grep "dddcifs") {
    umount /mnt/dddcifs
    }

    try {
    mount -t cifs -o username=$cifsusername,password=$cifspass $cifsserverpath /mnt/dddcifs
    } catch {
    Write-Host $Error
    $cifsoof = "y"
    }
    if ($cifsoof -ne "y") {
    Write-Host "Success!"

    umount /mnt/dddcifs

    $fstabexist = Select-String -Path /etc/fstab -Pattern "dddcifs"
    if ($fstabexist -ne $NULL) {

    (Get-Content /etc/fstab) -notmatch "dddcifs" | Set-Content /etc/fstab

    }
    $fstabline = $cifsserverpath + "  /mnt/dddcifs  cifs  username=" + $cifsusername + ",password=" + $cifspass + "  0  0"
    echo $fstabline >> /etc/fstab
    mount -a
    $cifsok = "y"
    }
    pause
    } while ( $cifsok -eq "n")


}

function nfsclientsetup {

   $nfsinstalled = apt-cache policy nfs-common | grep 'none'
    if ($cifsinstalled -ne $NULL) {
        apt install nfs-common
    }

    $nfsok = "N" 

    do {

    Clear-Host
    Write-Host "NFS SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Enter the complete server and share path."
    Write-Host "For example: 192.168.11.19:/DDDCaps"
    Write-Host ""
    $nfsserverpath = Read-Host

    Clear-Host
    Write-Host "NFS SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Enter the protocol. Normally (and default) TCP."
    Write-Host ""
    $nfsprotoprompt = Read-Host -Prompt "1) TCP 2) UDP"
    if ($nfsprotoprompt -eq "1") {
    $nfsproto = "tcp"
    }
    elseif ($nfsprotoprompt -eq "2") {
    $nfsproto = "udp"
    }
    else {
    $nfsproto = "tcp"
    }


    Clear-Host
    Write-Host "CIFS SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Enter the port. Typically 2049"
    Write-Host ""
    $nfsport = Read-Host

    Clear-Host
    Write-Host "CIFS SETUP"
    Write-Host ""
    Write-Host ""

    if (Test-Path /mnt/dddnfs) {}
    else {
    mkdir /mnt/dddnfs }

    if (mount | grep "dddnfs") {
    umount /mnt/dddnfs
    }

    try {
    mount -t nfs -o proto=$nfsproto,port=$nfsport $nfsserverpath /mnt/dddnfs
    } catch {
    Write-Host $Error
    $nfsoof = "y"
    }
    if ($nfsoof -ne "y") {
    Write-Host "Success!"

    umount /mnt/dddnfs

    $fstabexistnfs = Select-String -Path /etc/fstab -Pattern "dddnfs"
    if ($fstabexistnfs -ne $NULL) {

    (Get-Content /etc/fstab) -notmatch "dddnfs" | Set-Content /etc/fstab

    }
    $fstablinenfs = $nfsserverpath + "  /mnt/dddnfs  nfs  proto=" + $nfsproto + ",port=" + $nfsport + "  0  0"
    mount -a
    echo $fstablinenfs >> /etc/fstab
    $nfsok = "y"
    }
    pause
    } while ( $nfsok -eq "n")


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

do {
Clear-Host
Write-Host "CAPTURE SETUP"
Write-Host ""
Write-Host ""
Write-Host "DomePi supports capturing to USB3 SSD storage"
Write-Host "and over 1Gb network via CIFS (SMB) and NFS."
Write-Host "If you chose to capture to local storage, you"
Write-Host "will have the option of setting up a network"
Write-Host "share for accessing the capture files."
Write-Host ""
Write-Host "Would you like to capture to local storage or"
$capturechoice = Read-Host -Prompt "over the network? 1) Local 2) Network "

if ($capturechoice -eq "1") {
    $capturech = 1
}
elseif ($capturechoice -eq 2) {
    $capturech = 2
} else {
    $capturech = 3
}

} until ($capturech -eq 1 -or $capturech -eq 2)

if ($capturech -eq 1) {

    ##local setup here

}

if ($capturech -eq 2) {

    do {

    Clear-Host
    Write-Host "CAPTURE SETUP"
    Write-Host ""
    Write-Host ""
    Write-Host "Do you want to capture via NFS or CIFS (SMB)?"
    $capdestchoice = Read-Host -Prompt "1) NFS 2) CIFS "

    } until ($capdestchoice -eq "1" -or $capdestchoice -eq "2")

    if ($capdestchoice -eq "1") {
        
        nfsclientsetup

    }
    if ($capdestchoice -eq "2") {
        
        cifsclientsetup

    }


}
