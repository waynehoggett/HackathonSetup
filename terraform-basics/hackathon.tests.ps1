# Pester test script
Describe "Terraform Installation" -Tags 0 {
    It "Should have Terraform installed" {
        # Check if terraform command is available
        $terraformPath = Get-Command terraform -ErrorAction SilentlyContinue
        $terraformPath | Should -Not -BeNullOrEmpty
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

Describe "Configure Providers" -Tags 2 {
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
    It "Provider ersion is correct" {
        $RequiredString = Select-String -Pattern "3.116.0" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "Provider block is specifed" {
        $RequiredString = Select-String -Pattern "provider" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "skip_provider_registration is specifed" {
        $RequiredString = Select-String -Pattern "skip_provider_registration" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
    It "Features block exists" {
        $RequiredString = Select-String -Pattern "features" -SimpleMatch -Path "C:\Terraform\main.tf"
        $RequiredString | Should -Not -BeNullOrEmpty
    }
}