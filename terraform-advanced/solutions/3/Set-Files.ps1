
# Download the Module


# Install the module
terraform init

# Move the resource into the module
terraform state mv azurerm_storage_account.stg module.stg.azurerm_storage_account.stg

# Save the plan
terraform plan -no-color > tf3.plan