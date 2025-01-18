# Pre-reqs

## Install Modules and connect to Azure
Install-Module Az -Force
Connect-AzAccount -Identity

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

# 2
New-Item -Path "C:\" -Name "Bicep" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "C:\Bicep"

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/2/main.bicep' -Destination "C:\Bicep\main.bicep"

Connect-AzAccount -Identity

New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep"

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 3
New-Item -Path "C:\" -Name "Bicep" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "C:\Bicep"

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/3/main.bicep' -Destination "C:\Bicep\main.bicep"

Connect-AzAccount -Identity

## Deploy a second storage account, using parameters at the command line
New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -skuName 'Standard_ZRS' -nameFromTemplate "st$(Get-Random -Minimum 111111 -Maximum 999999)"

## Deploy a third storage account, using parameters in main.bicepparam
Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/3/main.bicepparam' -Destination "C:\Bicep\main.bicepparam"
New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -TemplateParameterFile "C:\Bicep\main.bicepparam"

# 4




# 5

# 6

# 7

# 8

# 9

# 10

# 11

# 12

# 13

# 14

# 15
