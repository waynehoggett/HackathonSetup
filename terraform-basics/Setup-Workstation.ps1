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

# Create tests directory
if (-not (Test-Path 'C:\Tests' -ErrorAction SilentlyContinue)) {
    $null = New-Item -Path 'C:\' -Name "Tests" -ItemType Directory
}

# Download Pester Tests
## Terraform basic hackathon tests
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-basics/hackathon.tests.ps1' -OutFile 'C:\Tests\hackathon.tests.ps1' -UseBasicParsing
## Pode Server file
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-basics/Server.ps1' -OutFile 'C:\Tests\Server.ps1' -UseBasicParsing

# Enable Access using Windows Firewall
New-NetFirewallRule -DisplayName "AllowPodeWebServer" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow

# Setup Pode as a Service
# As per: https://pode.readthedocs.io/en/stable/Hosting/RunAsService/
$exe = (Get-Command powershell.exe).Source
$name = 'Pode Web Server'
$file = 'C:\Tests\Server.ps1'
$arg = "-ExecutionPolicy Bypass -NoProfile -Command `"$($file)`""
nssm install $name $exe $arg
nssm start $name