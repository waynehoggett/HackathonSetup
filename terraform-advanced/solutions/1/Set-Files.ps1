Install-Module Az -Force
Connect-AzAccount -Identity

New-Item -Path "C:\" -Name "Terraform" -ItemType Directory -ErrorAction SilentlyContinue

Set-Location -Path "C:\Terraform"

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

az login --identity

terraform apply --auto-approve