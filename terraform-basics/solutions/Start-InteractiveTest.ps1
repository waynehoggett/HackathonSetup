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
choco install terraform -y
choco install azure-cli -y
code --install-extension HashiCorp.terraform

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 2
Write-Host "Starting Challenge 2"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/terraform-basics/solutions/2/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 3
Write-Host "Starting Challenge 3"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/terraform-basics/solutions/3/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

terraform init

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 4
Write-Host "Starting Challenge 4"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/terraform-basics/solutions/4/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

terraform fmt

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 5
Write-Host "Starting Challenge 5"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-basics/solutions/5/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing
$RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*lab*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_NAME%', "$($RG_NAME)") | Set-Content "C:\Terraform\main.tf"

terraform fmt
terraform validate

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 6
Write-Host "Starting Challenge 6"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-basics/solutions/6/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing
$RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*lab*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_NAME%', "$($RG_NAME)") | Set-Content "C:\Terraform\main.tf"

az login --identity
terraform fmt
terraform validate
terraform init
terraform plan
terraform apply --auto-approve

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 7
Write-Host "Starting Challenge 7"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-basics/solutions/7/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing
$RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*lab*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_NAME%', "$($RG_NAME)") | Set-Content "C:\Terraform\main.tf"

az login --identity
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply --auto-approve

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 8
Write-Host "Starting Challenge 8"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-basics/solutions/8/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing
$RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*lab*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_NAME%', "$($RG_NAME)") | Set-Content "C:\Terraform\main.tf"

az login --identity
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply --auto-approve

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 9
Write-Host "Starting Challenge 9"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-basics/solutions/9/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing
$RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*lab*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_NAME%', "$($RG_NAME)") | Set-Content "C:\Terraform\main.tf"

az login --identity
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply --auto-approve

Read-Host -Prompt "To Continue Press Enter (Partial completion)"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-basics/solutions/9/main-part2.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

$RG_NAME = Get-AzResourceGroup | Where-Object ResourceGroupName -like "*lab*" | Select-Object -ExpandProperty "ResourceGroupName"
(Get-Content "C:\Terraform\main.tf").Replace('%RG_NAME%', "$($RG_NAME)") | Set-Content "C:\Terraform\main.tf"

$STG_NAME = Get-AzStorageAccount | Select-Object -ExpandProperty "StorageAccountName"
(Get-Content "C:\Terraform\main.tf").Replace('%STG_NAME%', "$($STG_NAME)") | Set-Content "C:\Terraform\main.tf"

az login --identity
terraform fmt
terraform init -force-copy

Remove-Item -Path "C:\Terraform\terraform.tfstate" -Force
Remove-Item -Path "C:\Terraform\terraform.tfstate.backup" -Force

Read-Host -Prompt "Verify and Continue and then Press Enter"
