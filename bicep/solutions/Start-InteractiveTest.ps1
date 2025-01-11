# Pre-reqs

## Install Modules and connect to Azure
Install-Module Az -Force
Connect-AzAccount -Identity

## Setup the working directory
New-Item -Path "C:\" -Name "Bicep" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "C:\Bicep"

## Refresh the environment to get access to Choco
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

# 1
Write-Host "Starting Challenge 1"
choco install azure-cli -y
choco install bicep -y
code --install-extension ms-azuretools.vscode-bicep

Read-Host -Prompt "Verify and Continue and then Press Enter"