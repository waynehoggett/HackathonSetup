# Pre-reqs

## Install Modules and connect to Azure
Install-Module Az -Force
Connect-AzAccount -Identity

## Setup the working directory
New-Item -Path "C:\" -Name "Terraform" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "C:\Terraform"

## Refresh the environment to get access to Choco
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

# 1
Write-Host "Starting Challenge 1"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/1/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

$RG_ID = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*stg*" | Select-Object -ExpandProperty "ResourceId"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_ID%', "$($RG_ID)") | Set-Content "C:\Terraform\main.tf"

$RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*st*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_NAME%', "$($RG_NAME)") | Set-Content "C:\Terraform\main.tf"

$RG_LOCATION = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*stg*" | Select-Object -ExpandProperty "Location"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_LOCATION%', "$($RG_LOCATION)") | Set-Content "C:\Terraform\main.tf"

$STG_ID = Get-AzStorageAccount | Select-Object -ExpandProperty "Id"
(Get-Content "C:\Terraform\main.tf").Replace('%STG_ID%', "$($STG_ID)") | Set-Content "C:\Terraform\main.tf"

$STG_NAME = Get-AzStorageAccount | Select-Object -ExpandProperty "StorageAccountName"
(Get-Content "C:\Terraform\main.tf").Replace('%STG_NAME%', "$($STG_NAME)") | Set-Content "C:\Terraform\main.tf"

az login --identity
terraform init
terraform plan
terraform apply --auto-approve

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 2
Write-Host "Starting Challenge 2"