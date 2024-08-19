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