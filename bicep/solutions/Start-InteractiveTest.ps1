# Pre-reqs

## Install Modules and connect to Azure
Install-Module Az -Force
Connect-AzAccount -Identity

## Refresh the environment to get access to Choco
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

function Update-Tests {
    Start-BitsTransfer -Source "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/hackathon.tests.ps1" -Destination "C:\Tests\hackathon.tests.ps1"
}

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

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 4
Update-Tests

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/4/main.bicep' -Destination "C:\Bicep\main.bicep"

New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -WhatIf


# 5
Update-Tests
New-Item -Path "C:\" -Name "Output" -ItemType Directory -ErrorAction SilentlyContinue

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/5/main.bicep' -Destination "C:\Bicep\main.bicep"

## WhatIf Incremental
Get-AzResourceGroupDeploymentWhatIfResult -Mode Incremental -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" | Out-File "C:\Output\whatif1.txt"

## What If Complete
Get-AzResourceGroupDeploymentWhatIfResult -Mode Complete -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" | Out-File "C:\Output\whatif2.txt"

## Complete Deployment
New-AzResourceGroupDeployment -Mode Complete -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -Force

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
