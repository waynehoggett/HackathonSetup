
# Download the Module
New-Item "C:\Terraform\modules\terraform-azure-storage-account" -ItemType Directory
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/3/terraform-azure-storage-account/main.tf' -OutFile "C:\Terraform\modules\terraform-azure-storage-account\main.tf" -UseBasicParsing
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/3/terraform-azure-storage-account/outputs.tf' -OutFile "C:\Terraform\modules\terraform-azure-storage-account\outputs.tf" -UseBasicParsing
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-advanced/solutions/3/terraform-azure-storage-account/variables.tf' -OutFile "C:\Terraform\modules\terraform-azure-storage-account\variables.tf" -UseBasicParsing



# Install the module
terraform init

# Move the resource into the module
terraform state mv azurerm_storage_account.stg module.stg.azurerm_storage_account.stg

# Save the plan
terraform plan -no-color > tf3.plan