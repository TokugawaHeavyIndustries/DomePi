#!/usr/bin/pwsh

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
    echo "static ip setup here"
} else {}

echo "cont"
