# Set Preferences
$ProgressPreference = "SilentlyContinue"

# Skip OOBE
New-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "PrivacyConsentStatus" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "SkipMachineOOBE" -Value 1 -PropertyType DWORD -Force 
New-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "ProtectYourPC" -Value 3 -PropertyType DWORD -Force 
New-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "SkipUserOOBE" -Value 1 -PropertyType DWORD -Force

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Load the Chocolatey Module
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

# Refresh the environment to get access to Choco
refreshenv

## nssm for hosting Pode as a service using Chocolatey
choco install nssm -y
# Install VSCode using Chocolatey
choco install vscode -y

# Install Modules
Install-PackageProvider -Name Nuget -MinimumVersion 2.8.5.201 -Force
Install-Module Pode -MaximumVersion 2.11.1 -Force
Install-Module -Name Pester -Force -SkipPublisherCheck
Install-Module Az.Accounts, Az.Resources, Az.Storage -Scope AllUsers -Force

# Create tests directory
if (-not (Test-Path 'C:\Tests' -ErrorAction SilentlyContinue)) {
    $null = New-Item -Path 'C:\' -Name "Tests" -ItemType Directory
}

# Enable Access using Windows Firewall
New-NetFirewallRule -DisplayName "AllowPodeWebServer" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow