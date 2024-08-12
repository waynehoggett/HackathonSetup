# Set Preferences
$ProgressPreference = "SilentlyContinue"

# Skip OOBE
New-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "PrivacyConsentStatus" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "SkipMachineOOBE" -Value 1 -PropertyType DWORD -Force 
New-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "ProtectYourPC" -Value 3 -PropertyType DWORD -Force 
New-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "SkipUserOOBE" -Value 1 -PropertyType DWORD -Force

# Install Chocolatey (gave up on winget)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

# Refresh the environment to get access to Choco
refreshenv

# Install Software using Chocolatey
## vscode for the hackathon
choco install vscode -y
## nssm for hosting Pode as a service
choco install nssm -y

# Install Modules
Install-PackageProvider -Name Nuget -MinimumVersion 2.8.5.201 -Force
Install-Module Pode -Force
Install-Module -Name Pester -Force -SkipPublisherCheck

# Download Pester Tests
## Terraform basic hackathon tests
https://gist.githubusercontent.com/waynehoggett/23149ad1b154189f6a51a00753c7a1f7/raw/TerraformBasics.tests.ps1
## Pode Server file
https://gist.githubusercontent.com/waynehoggett/90f363c1510e5590579d1e6eac272c1a/raw//Server.ps1

# Setup Pode as a Service
# As per: https://pode.readthedocs.io/en/stable/Hosting/RunAsService/
$exe = (Get-Command powershell.exe).Source
$name = 'Pode Web Server'
$file = 'C:\Tests\Server.ps1'
$arg = "-ExecutionPolicy Bypass -NoProfile -Command `"$($file)`""
nssm install $name $exe $arg
nssm start $name