# Pester test script
Describe "Import Resources and Generate Configuration" -Tags 0 {
    It "State should exist locally" {
        $State = Get-Item -Path "C:\Terraform\terraform.tfstate"
        $State | Should -Not -BeNullOrEmpty
    }
    It "Managed Resource Group is present in state" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredResource = $State.resources | Where-Object { $_.type -eq "azurerm_resource_group" -and $_.mode -eq "managed" }
        $RequiredResource | Should -Not -BeNullOrEmpty
    }
    It "Managed Storage Account is present in state" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredResource = $State.resources | Where-Object { $_.type -eq "azurerm_storage_account" -and $_.mode -eq "managed" }
        $RequiredResource | Should -Not -BeNullOrEmpty
    }
    It "Storage Account replication type is LRS" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredValue = "LRS"
        $ActualValue = ($State.resources | Where-Object { $_.type -eq "azurerm_storage_account" }).instances[0].attributes.account_replication_type
        $ActualValue | Should -Be $RequiredValue
    }
    It "Storage Account tier type is Standard" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredValue = "Standard"
        $ActualValue = ($State.resources | Where-Object { $_.type -eq "azurerm_storage_account" }).instances[0].attributes.account_tier
        $ActualValue | Should -Be $RequiredValue
    }
    It "Storage Account network_rules Default Action is Deny" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredValue = "Deny"
        $ActualValue = ($State.resources | Where-Object { $_.type -eq "azurerm_storage_account" }).instances[0].attributes.network_rules.default_action
        $ActualValue | Should -Be $RequiredValue
    }
}

Describe "Resolve Provider Issues" -Tags 1 {
    It "Storage Account network_rules Default Action is Deny" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredValue = "Deny"
        $ActualValue = ($State.resources | Where-Object { $_.type -eq "azurerm_storage_account" }).instances[0].attributes.network_rules.default_action
        $ActualValue | Should -Be $RequiredValue
    }
    It "State contains required resources" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $StateObjectCount = $State.Resources.Count
        $StateObjectCount | Should -BeGreaterOrEqual 3
    }
    It "State contains thumbnails resource" {
        $RequiredString = Select-String -Pattern "thumbnails" -SimpleMatch -Path "C:\Terraform\terraform.tfstate"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
}

Describe "Import Resources and Generate Configuration" -Tags 2 {
    It "modules exists" {
        $RequiredItem = Get-Item -Path "C:\Terraform\modules"
        $RequiredItem | Should -Not -BeNullOrEmpty
    }
    It "terraform-azure-storage-account exists" {
        $RequiredItem = Get-Item -Path "C:\Terraform\modules\terraform-azure-storage-account"
        $RequiredItem | Should -Not -BeNullOrEmpty
    }
    It "main.tf exists" {
        $RequiredItem = Get-Item -Path "C:\Terraform\modules\terraform-azure-storage-account\main.tf"
        $RequiredItem | Should -Not -BeNullOrEmpty
    }
    It "outputs.tf exists" {
        $RequiredItem = Get-Item -Path "C:\Terraform\modules\terraform-azure-storage-account\outputs.tf"
        $RequiredItem | Should -Not -BeNullOrEmpty
    }
    It "variables.tf exists" {
        $RequiredItem = Get-Item -Path "C:\Terraform\modules\terraform-azure-storage-account\variables.tf"
        $RequiredItem | Should -Not -BeNullOrEmpty
    }
    It "Output is defined in Module outputs.tf" {
        $RequiredString = Select-String -Pattern "output" -SimpleMatch -Path "C:\Terraform\modules\terraform-azure-storage-account\outputs.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "resource_id is defined in Module outputs.tf" {
        $RequiredString = Select-String -Pattern "resource_id" -SimpleMatch -Path "C:\Terraform\modules\terraform-azure-storage-account\outputs.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "Module is consumed in main.tf" {
        $RequiredString = Select-String -Pattern "module" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "azurerm_storage_account is defined in module main.tf" {
        $RequiredString = Select-String -Pattern "azurerm_storage_account" -SimpleMatch -Path "C:\Terraform\modules\terraform-azure-storage-account\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "azurerm_storage_account should NOT be defined in top level main.tf" {
        $RequiredString = Select-String -Pattern "azurerm_storage_account" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -BeNullOrEmpty
    }
    It "tf3.plan should contain No changes." {
        $RequiredString = Select-String -Pattern "No changes" -SimpleMatch -Path "C:\Terraform\tf3.plan"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
}

Describe "Create Multiple Resources" -Tags 3 {
    It "Managed Storage Account Count is 4 in State" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredResourceCount = ($State.resources | Where-Object { $_.type -eq "azurerm_storage_account" -and $_.mode -eq "managed" }).Count
        $RequiredResourceCount | Should -Be 4
    }
    It "State contains a resource that ends with a 1" {
        $RequiredString = Select-String -Pattern '"name": "\w*1"' -Path "C:\Terraform\terraform.tfstate"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "State contains a resource that ends with a 2" {
        $RequiredString = Select-String -Pattern '"name": "\w*2"' -Path "C:\Terraform\terraform.tfstate"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "State contains a resource that ends with a 3" {
        $RequiredString = Select-String -Pattern '"name": "\w*3"' -Path "C:\Terraform\terraform.tfstate"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    
}

Describe "Create Multiple Resources" -Tags 4 {
    It "tf4.plan should contain Plan: 0 to add, 0 to change, 1 to destroy." {
        $RequiredString = Select-String -Pattern "Plan: 0 to add, 0 to change, 1 to destroy." -SimpleMatch -Path "C:\Terraform\tf4.plan"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
}

Describe "Create Multiple Resources" -Tags 5 {
    It "SQL Database Collation is SQL_Latin1_General_CP1_CI_AS" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredValue = "SQL_Latin1_General_CP1_CI_AS"
        $ActualValue = ($State.resources | Where-Object { $_.type -eq "azurerm_mssql_database" }).instances[0].attributes.collation
        $ActualValue | Should -Be $RequiredValue
    }
    It "SQL Database sku_name is S0" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredValue = "S0"
        $ActualValue = ($State.resources | Where-Object { $_.type -eq "azurerm_mssql_database" }).instances[0].attributes.sku_name
        $ActualValue | Should -Be $RequiredValue
    }
    It "SQL Database max_size_gb is 2" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredValue = "2"
        $ActualValue = ($State.resources | Where-Object { $_.type -eq "azurerm_mssql_database" }).instances[0].attributes.max_size_gb
        $ActualValue | Should -Be $RequiredValue
    }
    It "All resources and resource groups are tagged" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $ValidTags = $true
        foreach ($Resource in $State.resources) {
            foreach ($Instance in $Resource.instances) {
                # Only check resources that have tags
                if ($Instance.attributes.tags) {
                    if ($Instance.attributes.tags.environment -ne "hackathon" -or $Instance.attributes.tags.source -ne "terraform") {
                        $ValidTags = $false
                    }
                }
            }
        }
        $ValidTags | Should -Be $true
    }
}