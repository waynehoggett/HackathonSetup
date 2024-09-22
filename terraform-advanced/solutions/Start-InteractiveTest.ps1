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

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/2/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

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

# 3
Write-Host "Starting Challenge 3"

New-Item "C:\Terraform\modules\terraform-azure-storage-account" -ItemType Directory -Force
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/3/terraform-azure-storage-account/main.tf' -OutFile "C:\Terraform\modules\terraform-azure-storage-account\main.tf" -UseBasicParsing
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/3/terraform-azure-storage-account/outputs.tf' -OutFile "C:\Terraform\modules\terraform-azure-storage-account\outputs.tf" -UseBasicParsing
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/3/terraform-azure-storage-account/variables.tf' -OutFile "C:\Terraform\modules\terraform-azure-storage-account\variables.tf" -UseBasicParsing

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/3/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

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

terraform init
terraform state mv azurerm_storage_account.stg module.stg.azurerm_storage_account.stg
terraform plan -no-color > tf3.plan

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 4
Write-Host "Starting Challenge 4"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/4/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

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

terraform init
terraform plan
terraform apply --auto-approve

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 5
Write-Host "Starting Challenge 5"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/5/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

$RG_ID = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*stg*" | Select-Object -ExpandProperty "ResourceId"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_ID%', "$($RG_ID)") | Set-Content "C:\Terraform\main.tf"

$RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*st*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_NAME%', "$($RG_NAME)") | Set-Content "C:\Terraform\main.tf"

$RG_LOCATION = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*stg*" | Select-Object -ExpandProperty "Location"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_LOCATION%', "$($RG_LOCATION)") | Set-Content "C:\Terraform\main.tf"

$STG_ID = Get-AzStorageAccount | Select-Object -ExpandProperty "Id"
(Get-Content "C:\Terraform\main.tf").Replace('%STG_ID%', "$($STG_ID)") | Set-Content "C:\Terraform\main.tf"

$STG_NAME = Get-AzStorageAccount | Select-Object -ExpandProperty "StorageAccountName" | Where-Object { $_ -notmatch "[123]$" }
(Get-Content "C:\Terraform\main.tf").Replace('%STG_NAME%', "$($STG_NAME)") | Set-Content "C:\Terraform\main.tf"

terraform init

terraform state mv 'module.multiplestg[0].azurerm_storage_account.stg' 'module.multiplestg[\"1\"].azurerm_storage_account.stg'
terraform state mv 'module.multiplestg[2].azurerm_storage_account.stg' 'module.multiplestg[\"3\"].azurerm_storage_account.stg'

terraform plan -no-color > tf4.plan

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 6
Write-Host "Starting Challenge 6"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/6/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

$RG_ID = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*stg*" | Select-Object -ExpandProperty "ResourceId"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_ID%', "$($RG_ID)") | Set-Content "C:\Terraform\main.tf"

$RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*st*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_NAME%', "$($RG_NAME)") | Set-Content "C:\Terraform\main.tf"

$RG_LOCATION = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*stg*" | Select-Object -ExpandProperty "Location"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_LOCATION%', "$($RG_LOCATION)") | Set-Content "C:\Terraform\main.tf"

$STG_ID = Get-AzStorageAccount | Select-Object -ExpandProperty "Id"
(Get-Content "C:\Terraform\main.tf").Replace('%STG_ID%', "$($STG_ID)") | Set-Content "C:\Terraform\main.tf"

$STG_NAME = Get-AzStorageAccount | Select-Object -ExpandProperty "StorageAccountName" | Where-Object { $_ -notmatch "[123]$" }
(Get-Content "C:\Terraform\main.tf").Replace('%STG_NAME%', "$($STG_NAME)") | Set-Content "C:\Terraform\main.tf"

$SQL_RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*sql*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%SQL_RG_NAME%', "$($SQL_RG_NAME)") | Set-Content "C:\Terraform\main.tf"

terraform init
terraform plan
terraform apply --auto-approve

Read-Host -Prompt "To Continue Press Enter (Partial completion)"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/6/main-part2.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

$RG_ID = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*stg*" | Select-Object -ExpandProperty "ResourceId"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_ID%', "$($RG_ID)") | Set-Content "C:\Terraform\main.tf"

$RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*st*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_NAME%', "$($RG_NAME)") | Set-Content "C:\Terraform\main.tf"

$RG_LOCATION = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*stg*" | Select-Object -ExpandProperty "Location"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_LOCATION%', "$($RG_LOCATION)") | Set-Content "C:\Terraform\main.tf"

$STG_ID = Get-AzStorageAccount | Select-Object -ExpandProperty "Id"
(Get-Content "C:\Terraform\main.tf").Replace('%STG_ID%', "$($STG_ID)") | Set-Content "C:\Terraform\main.tf"

$STG_NAME = Get-AzStorageAccount | Select-Object -ExpandProperty "StorageAccountName" | Where-Object { $_ -notmatch "[123]$" }
(Get-Content "C:\Terraform\main.tf").Replace('%STG_NAME%', "$($STG_NAME)") | Set-Content "C:\Terraform\main.tf"

$SQL_RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*sql*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%SQL_RG_NAME%', "$($SQL_RG_NAME)") | Set-Content "C:\Terraform\main.tf"

$SQL_RG_ID = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*sql*" | Select-Object -ExpandProperty "ResourceId"
(Get-Content "C:\Terraform\main.tf").Replace('%SQL_RG_ID%', "$($SQL_RG_ID)") | Set-Content "C:\Terraform\main.tf"

$SQL_RG_LOCATION = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*sql*" | Select-Object -ExpandProperty "Location"
(Get-Content "C:\Terraform\main.tf").Replace('%SQL_RG_LOCATION%', "$($SQL_RG_LOCATION)") | Set-Content "C:\Terraform\main.tf"

New-Item "C:\Terraform\modules\terraform-azure-storage-account" -ItemType Directory -Force
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/6/terraform-azure-storage-account/main.tf' -OutFile "C:\Terraform\modules\terraform-azure-storage-account\main.tf" -UseBasicParsing
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/6/terraform-azure-storage-account/outputs.tf' -OutFile "C:\Terraform\modules\terraform-azure-storage-account\outputs.tf" -UseBasicParsing
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/6/terraform-azure-storage-account/variables.tf' -OutFile "C:\Terraform\modules\terraform-azure-storage-account\variables.tf" -UseBasicParsing

terraform init
terraform plan
terraform apply --auto-approve