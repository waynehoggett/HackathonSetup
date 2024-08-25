# Pester test script
Describe " Install Software and VS Code Extensions" -Tags 0 {
    It "Should have Terraform installed" {
        $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
        Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
        Update-SessionEnvironment
        $terraformPath = Get-Command terraform -ErrorAction SilentlyContinue
        $terraformPath | Should -Not -BeNullOrEmpty
    }
    It "Should have Azure CLI installed" {
        $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
        Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
        Update-SessionEnvironment
        $azpath = Get-Command az -ErrorAction SilentlyContinue
        $azpath | Should -Not -BeNullOrEmpty
    }
    It "Should have Visual Studio Code Extension installed: Hashicorp Terraform" {
        $UserPath = Get-ChildItem C:\Users | Where-Object Name -like "Hacker*" | Select-Object -ExpandProperty FullName
        $VSCodeExtensionPath = Join-Path -Path $UserPath -ChildPath ".vscode\extensions"
        $HashicorpExtensionDirectory = Get-ChildItem $VSCodeExtensionPath | Where-Object Name -like "*hashicorp*terraform*"
        $HashicorpExtensionDirectory | Should -Not -BeNullOrEmpty
    }
}

Describe "Configure Terraform" -Tags 1 {
    It "C:\Terraform\main.tf should exist" {
        $File = Get-Item -Path "C:\Terraform\main.tf" -ErrorAction SilentlyContinue
        $File | Should -Not -BeNullOrEmpty
    }
    It "main.tf should include the terraform block" {
        $RequiredString = Select-String -Pattern "terraform" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "main.tf should include the pessimistic constraint operator" {
        $RequiredString = Select-String -Pattern "~>" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "main.tf should include the required version: 1.9.4" {
        $RequiredString = Select-String -Pattern "1.9.4" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
}

Describe "Configure Required Providers" -Tags 2 {
    It "C:\Terraform\main.tf should exist" {
        $File = Get-Item -Path "C:\Terraform\main.tf" -ErrorAction SilentlyContinue
        $File | Should -Not -BeNullOrEmpty
    }
    It "Provider source is specified" {
        $RequiredString = Select-String -Pattern "source" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "Provider source is correct" {
        $RequiredString = Select-String -Pattern "hashicorp/azurerm" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "Provider version is specified" {
        $RequiredString = Select-String -Pattern "version" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "Provider version is correct" {
        $RequiredString = Select-String -Pattern "4.0.0" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "azurerm provider should be downloaded to C:\Terraform\.terraform" {
        $Path = Get-Item -Path "C:\Terraform\.terraform\providers\registry.terraform.io\hashicorp\azurerm" -ErrorAction SilentlyContinue
        $Path | Should -Not -BeNullOrEmpty
    }
}

Describe "Configure Provider" -Tags 3 {
    It "Provider block is specifed" {
        $RequiredString = Select-String -Pattern "provider" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "resource_provider_registrations is specifed" {
        $RequiredString = Select-String -Pattern "resource_provider_registrations" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "subscription_id argument is specifed" {
        $RequiredString = Select-String -Pattern "subscription_id" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "subscription_id value is specifed" {
        $RequiredString = Select-String -Pattern "847cb8f3-802b-42ab-aa9b-fe9d17d25580" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "Features block exists" {
        $RequiredString = Select-String -Pattern "features" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
}

Describe "Reference Existing Resources" -Tags 4 {
    It "Data block is specifed" {
        $RequiredString = Select-String -Pattern "data" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "azurerm_resource_group data type is specifed" {
        $RequiredString = Select-String -Pattern "azurerm_resource_group" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "name argument is specified" {
        $RequiredString = Select-String -Pattern "name" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
}

Describe "Deploy a Virtual Network" -Tags 5 {
    It "resource block is specifed" {
        $RequiredString = Select-String -Pattern "resource" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "azurerm_virtual_network resource type is specifed" {
        $RequiredString = Select-String -Pattern "azurerm_virtual_network" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "Virtual Network address space is 10.0.0.0/16 in state" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredValue = "10.0.0.0/16"
        $ActualValue = ($State.resources | Where-Object { $_.type -eq "azurerm_virtual_network" }).instances.attributes.address_space
        $ActualValue | Should -Be $RequiredValue
    }
    It "First Virtual Network subnet address space is 10.0.0.0/24 in state" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredValue = "10.0.0.0/24"
        $ActualValue = ($State.resources | Where-Object { $_.type -eq "azurerm_virtual_network" }).instances.attributes.subnet[0].address_prefixes[0]
        $ActualValue | Should -Be $RequiredValue
    }
    ($State.resources | Where-Object { $_.type -eq "azurerm_virtual_network" }).instances.attributes.subnet[0].address_prefixes[0]
    It "Managed Virtual Network is present in state" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredResource = $State.resources | Where-Object { $_.type -eq "azurerm_virtual_network" -and $_.mode -eq "managed" }
        $RequiredResource | Should -Not -BeNullOrEmpty
    }
    It "Data Resource Group is present in state" {
        $State = Get-Content -Path "C:\Terraform\terraform.tfstate" | ConvertFrom-Json
        $RequiredResource = $State.resources | Where-Object { $_.type -eq "azurerm_resource_group" -and $_.mode -eq "data" }
        $RequiredResource | Should -Not -BeNullOrEmpty
    }
    
}