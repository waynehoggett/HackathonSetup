# Pester test script
Describe " Install Software and VS Code Extensions" -Tags 0 {
    It "Should have Azure CLI or Azure PowerShell installed" {
        $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
        Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
        Update-SessionEnvironment
        $azcli = Get-Command az -ErrorAction SilentlyContinue
        $azpsmodule = Get-Module Az -ListAvailable
        $azcliInstalled = $azcli -ne $null 
        $azpsmoduleInstalled = $azpsmodule -ne $null 
        ($azcliInstalled -or $azpsmoduleInstalled) | Should -Be $True
    }
    It "Should have the Bicep CLI Installed" {
        $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
        Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
        Update-SessionEnvironment
        $bicep = Get-Command bicep -ErrorAction SilentlyContinue
        $bicep | Should -Not -BeNullOrEmpty
    }
    It "Should have Visual Studio Code Extension installed: Hashicorp Terraform" {
        $UserPath = Get-ChildItem C:\Users | Where-Object Name -like "Hacker*" | Select-Object -ExpandProperty FullName
        $VSCodeExtensionPath = Join-Path -Path $UserPath -ChildPath ".vscode\extensions"
        $BicepExtensionDirectory = Get-ChildItem $VSCodeExtensionPath | Where-Object Name -like "*bicep*"
        $BicepExtensionDirectory | Should -Not -BeNullOrEmpty
    }
}
Describe "Deploy Your First Bicep Resource" -Tags 1 {
    BeforeAll {
        Connect-AzAccount -Identity
    }
    It "C:\Bicep\main.bicep should exist" {
        $BicepFile = Test-Path -Path "C:\Bicep\main.bicep"
        $BicepFile | Should -Be $True
    }
    It "One Storage Account should exist" {
        $StorageAccount = Get-AzStorageAccount
        ($StorageAccount | Measure-Object).Count | Should -Be 1
    }
    It "Storage Account Location should be Australia East" {
        $StorageAccount = Get-AzStorageAccount
        $StorageAccount.Location | Should -Be "australiaeast"
    }
    It "Storage Account Kind should be StorageV2" {
        $StorageAccount = Get-AzStorageAccount
        $StorageAccount.Kind | Should -Be "StorageV2"
    }
    It "Storage Account SKU should be Standard_LRS" {
        $StorageAccount = Get-AzStorageAccount
        $StorageAccount.Sku.Name | Should -Be "Standard_LRS"
    }
}

Describe "Make Your Bicep File Reusable" -Tags 2 {
    BeforeAll {
        Connect-AzAccount -Identity
    }
    It "main.bicep should contain 3 parameters" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $ParameterCount = ($BicepFile | Select-String -Pattern "param" | Measure-Object).Count
        $ParameterCount | Should -Be 3
    }
    It "main.bicep should contain @minLength(3)" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $StorageAccountName = $BicepFile | Select-String -Pattern "@minLength(3)"
        $StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "main.bicep should contain @maxLength(24)" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $StorageAccountName = $BicepFile | Select-String -Pattern "@maxLength(24)"
        $StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "main.bicep should contain resourceGroup().location" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $Location = $BicepFile | Select-String -Pattern "resourceGroup().location"
        $Location | Should -Not -BeNullOrEmpty
    }
    It "main.bicep should contain @allowed" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $Allowed = $BicepFile | Select-String -Pattern "@allowed"
        $Allowed | Should -Not -BeNullOrEmpty
    }
    It "main.bicep should contain = 'Standard_LRS'" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $Sku = $BicepFile | Select-String -Pattern "= 'Standard_LRS'"
        $Sku | Should -Not -BeNullOrEmpty
    }
    It "main.bicepparam should exist" {
        $BicepParamFile = Test-Path -Path "C:\Bicep\main.bicepparam"
        $BicepParamFile | Should -Be $True
    }
    It "main.bicepparam should contain 'Standard_ZRS'" {
        $BicepParamFile = Get-Content -Path "C:\Bicep\main.bicepparam"
        $Sku = $BicepParamFile | Select-String -Pattern "Standard_ZRS"
        $Sku | Should -Not -BeNullOrEmpty
    }
    It "Storage Account count should be 3" {
        $StorageAccount = Get-AzStorageAccount
        ($StorageAccount | Measure-Object).Count | Should -Be 3
    }
    It "Two Storage Accounts should exist with the SKU Standard_LRS" {
        $StorageAccount = Get-AzStorageAccount
        $StorageAccount | Where-Object SkuName -eq "Standard_LRS" | Should -HaveCount 2
    }
    It "A Storage Account with the SKU Standard_ZRS should exist" {
        $StorageAccount = Get-AzStorageAccount
        $StorageAccount | Where-Object SkuName -eq "Standard_ZRS" | Should -Not -BeNullOrEmpty
    }
}