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
Update-Tests
choco install azure-cli -y
choco install bicep -y
code --install-extension ms-azuretools.vscode-bicep

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 2
Write-Host "Starting Challenge 2"
Update-Tests
New-Item -Path "C:\" -Name "Bicep" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "C:\Bicep"

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/2/main.bicep' -Destination "C:\Bicep\main.bicep"

Connect-AzAccount -Identity

New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep"

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 3
Write-Host "Starting Challenge 3"
Update-Tests
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
Write-Host "Starting Challenge 4"
Update-Tests

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/4/main.bicep' -Destination "C:\Bicep\main.bicep"

New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -WhatIf

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 5
Write-Host "Starting Challenge 5"
Update-Tests
New-Item -Path "C:\" -Name "Output" -ItemType Directory -ErrorAction SilentlyContinue

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/5/main.bicep' -Destination "C:\Bicep\main.bicep"

## WhatIf Incremental
Get-AzResourceGroupDeploymentWhatIfResult -Mode Incremental -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" | Out-File "C:\Output\whatif1.txt"

## What If Complete
Get-AzResourceGroupDeploymentWhatIfResult -Mode Complete -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" | Out-File "C:\Output\whatif2.txt"

## Complete Deployment
New-AzResourceGroupDeployment -Mode Complete -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -Force

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 6
Write-Host "Starting Challenge 6"
Update-Tests

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/6/main.bicep' -Destination "C:\Bicep\main.bicep"

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 7
Write-Host "Starting Challenge 7"
Update-Tests

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/7/main.bicep' -Destination "C:\Bicep\main.bicep"

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 8
Write-Host "Starting Challenge 8"
Update-Tests

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/8/main.bicep' -Destination "C:\Bicep\main.bicep"

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 9
Write-Host "Starting Challenge 9"
Update-Tests

Connect-AzAccount -Identity

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/9/main.bicep' -Destination "C:\Bicep\main.bicep"

New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -Force -Count 1 -dataConfidentialityLevel "SENSITIVE"

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 10
Write-Host "Starting Challenge 10"
Update-Tests

Connect-AzAccount -Identity

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/10/main.bicep' -Destination "C:\Bicep\main.bicep"

$VNetResourceGroup = (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-vnet-*").ResourceGroupName
(Get-Content "C:\Bicep\main.bicep").Replace('%VNET_RESOURCE_GROUP%', "$($VNetResourceGroup)") | Set-Content "C:\Bicep\main.bicep"

New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -Force -Count 1 -dataConfidentialityLevel "SENSITIVE"

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 11
Write-Host "Starting Challenge 11"
Update-Tests

Connect-AzAccount -Identity

Start-BitsTransfer -Source 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/solutions/11/main.bicep' -Destination "C:\Bicep\main.bicep"

$VNetResourceGroup = (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-vnet-*").ResourceGroupName
(Get-Content "C:\Bicep\main.bicep").Replace('%VNET_RESOURCE_GROUP%', "$($VNetResourceGroup)") | Set-Content "C:\Bicep\main.bicep"

# Remove existing storage accounts before continuing
Get-AzStorageAccount | Remove-AzStorageAccount -Force

$StorageAccount1 = @{dataConfidentialityLevel = "OFFICIAL"; skuName = "Standard_LRS"}
$StorageAccount2 = @{dataConfidentialityLevel = "SENSITIVE"; skuName = "Standard_ZRS"}
$StorageAccount3 = @{dataConfidentialityLevel = "PROTECTED"; skuName = "Standard_GRS"}
$StorageAccounts = $StorageAccount1, $StorageAccount2, $StorageAccount3
New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -Force -storageAccounts $StorageAccounts


Read-Host -Prompt "Verify and Continue and then Press Enter"

# 12
Write-Host "Starting Challenge 12"
Update-Tests

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 13
Write-Host "Starting Challenge 13"
Update-Tests

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 14
Write-Host "Starting Challenge 14"
Update-Tests

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 15
Write-Host "Starting Challenge 15"
Update-Tests

Read-Host -Prompt "Verify and Continue and then Press Enter"