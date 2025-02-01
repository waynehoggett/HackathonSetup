# Pester test script

# Challenge 1 - Set-up Your Environment

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

# Challenge 2 - Deploy Your First Bicep Resource

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

# Challenge 3 - Make Your Bicep File Reusable

Describe "Make Your Bicep File Reusable" -Tags 2 {
    BeforeAll {
        Connect-AzAccount -Identity
    }
    It "main.bicep should contain 3 parameters" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $ParameterCount = ($BicepFile | Select-String -Pattern "param" | Measure-Object).Count
        $ParameterCount | Should -Be 3
    }
    It "main.bicep should contain australiaeast" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $Location = $BicepFile | Select-String -Pattern "australiaeast"
        $Location | Should -Not -BeNullOrEmpty
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
    It "main.bicepparam should contain 'Standard_GRS'" {
        $BicepParamFile = Get-Content -Path "C:\Bicep\main.bicepparam"
        $Sku = $BicepParamFile | Select-String -Pattern "Standard_GRS"
        $Sku | Should -Not -BeNullOrEmpty
    }
    It "Storage Account count should be 3" {
        $StorageAccount = Get-AzStorageAccount
        ($StorageAccount | Measure-Object).Count | Should -Be 3
    }
    It "A Storage Account with the SKU Standard_LRS should exist" {
        $StorageAccount = Get-AzStorageAccount
        ($StorageAccount | Select-Object -ExpandProperty Sku).Name | Where-Object {$_ -eq "Standard_LRS"} | Should -Not -BeNullOrEmpty
    }
    It "A Storage Account with the SKU Standard_GRS should exist" {
        $StorageAccount = Get-AzStorageAccount
        ($StorageAccount | Select-Object -ExpandProperty Sku).Name | Where-Object {$_ -eq "Standard_GRS"} | Should -Not -BeNullOrEmpty
    }
    It "A Storage Account with the SKU Standard_ZRS should exist" {
        $StorageAccount = Get-AzStorageAccount
        ($StorageAccount | Select-Object -ExpandProperty Sku).Name | Where-Object {$_ -eq "Standard_ZRS"} | Should -Not -BeNullOrEmpty
    }
}

# Challenge 4 - Using Expressions

Describe "Using Expressions" -Tags 3 {
    BeforeAll {
        Connect-AzAccount -Identity
    }
    It "A deployment with no parameters should have one resource with no changes" {
        $Results = Get-AzResourceGroupDeploymentWhatIfResult -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep"
        ($Results.Changes | Where-Object ChangeType -eq "NoChange").Count | Should -Be 1
    }

}

# Challenge 5 - What If and Deployment Modes

Describe "What If and Deployment Modes" -Tags 4 {

    BeforeAll {
        Connect-AzAccount -Identity
    }
    It "C:\Output\whatif1.txt should contain 1 resource with no change" {
        $WhatIfFile = Get-Content -Path "C:\Output\whatif1.txt"
        $NoChange = $WhatIfFile | Select-String -Pattern "1 no change"
        $NoChange | Should -Not -BeNullOrEmpty
    }
    It "C:\Output\whatif2.txt should contain resources to delete" {
        $WhatIfFile = Get-Content -Path "C:\Output\whatif2.txt"
        $NoChange = $WhatIfFile | Select-String -Pattern "to delete"
        $NoChange | Should -Not -BeNullOrEmpty
    }
    It "One Storage Account should exist" {
        $StorageAccount = Get-AzStorageAccount
        ($StorageAccount | Measure-Object).Count | Should -Be 1
    }

}

# Challenge 6 - Decorating Parameters, and Interpolation

Describe "Decorating Parameters, and Interpolation" -Tags 5 {
    BeforeAll {
        Connect-AzAccount -Identity
    }
    It "main.bicep should contain @minLength(3)" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $StorageAccountName = $BicepFile | Select-String -Pattern "@minLength(3)" -SimpleMatch
        $StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "main.bicep should contain @maxLength(24)" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $StorageAccountName = $BicepFile | Select-String -Pattern "@maxLength(24)" -SimpleMatch
        $StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "main.bicep should contain 'st" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $StorageAccountName = $BicepFile | Select-String -Pattern "'st" -SimpleMatch
        $StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "main.bicep should contain @allowed" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $Allowed = $BicepFile | Select-String -Pattern "@allowed"
        $Allowed | Should -Not -BeNullOrEmpty
    }
    It "Deploying main.bicep using a name with a length over 24 should fail" {
        {New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -NameFromTemplate "asdfghjklqwertyuiopzxcvbnm1234" -WhatIf }| Should -Throw
    }
    It "Deploying main.bicep using an invalid skuName should fail" {
        {New-AzResourceGroupDeployment -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -TemplateFile "C:\Bicep\main.bicep" -skuName "asdfghjklqwertyuiopzxcvbnm1234" -WhatIf -ErrorAction Stop } | Should -Throw
    }
}

# Challenge 7 - Deploying Multiple Resources with Loops and Batching

Describe "Symbolic Names and Outputs" -Tags 6 {
    It "main.bicep should contain count parameter and default value" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $StorageAccountName = $BicepFile | Select-String -Pattern "param count int = 1" -SimpleMatch
        $StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "main.bicep should contain @maxValue(9)" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $StorageAccountName = $BicepFile | Select-String -Pattern "@maxValue(9)" -SimpleMatch
        $StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "main.bicep should contain @batchSize(3)" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $StorageAccountName = $BicepFile | Select-String -Pattern "@batchSize(3)" -SimpleMatch
        $StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "A storage account with a name starting with st and ending with 1 should exist" {
        $StorageAccount = Get-AzStorageAccount
        ($StorageAccount | Where-Object StorageAccountName -like "st*1").StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "A storage account with a name starting with st and ending with 2 should exist" {
        $StorageAccount = Get-AzStorageAccount
        ($StorageAccount | Where-Object StorageAccountName -like "st*2").StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "A storage account with a name starting with st and ending with 2 should exist" {
        $StorageAccount = Get-AzStorageAccount
        ($StorageAccount | Where-Object StorageAccountName -like "st*2").StorageAccountName | Should -Not -BeNullOrEmpty
    }
}


# Challenge 8 - Symbolic Names and Outputs
Describe "Symbolic Names and Outputs" -Tags 7 {
    It "main.bicep should contain an array output named storageAccountNames" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $StorageAccountName = $BicepFile | Select-String -Pattern "output storageAccountNames array" -SimpleMatch
        $StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "main.bicep should contain an array output named blobServiceUris" {
        $BicepFile = Get-Content -Path "C:\Bicep\main.bicep"
        $StorageAccountName = $BicepFile | Select-String -Pattern "output blobServiceUris array" -SimpleMatch
        $StorageAccountName | Should -Not -BeNullOrEmpty
    }
    It "When deployed, main.bicep should have 3 items in the output storageAccountNames" {
        $StorageAccountNames = (Get-AzResourceGroupDeploymentOutput -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -OutputName storageAccountNames).Value
        $StorageAccountNames.Count | Should -Be 3
    }
    It "When deployed, main.bicep should have 3 items in the output blobServiceUris" {
        $StorageAccountNames = (Get-AzResourceGroupDeploymentOutput -ResourceGroupName (Get-AzResourceGroup | Where-Object ResourceGroupName -like "rg-lab-*").ResourceGroupName -OutputName storageAccountNames).Value
        $StorageAccountNames.Count | Should -Be 3
    }
}


# # Challenge 9 - Conditional Deployments
# Describe "Symbolic Names and Outputs" -Tags 8 {
#     It "" {

#     }
# }

# # Challenge 10 - Working with Existing Resources and Scopes
# Describe "Symbolic Names and Outputs" -Tags 9 {
#     It "" {

#     }
# }

# # Challenge 11 - Advanced Parameters and Nesting
# Describe "Symbolic Names and Outputs" -Tags 10 {
#     It "" {

#     }
# }

# # Challenge 12 - Linting and Testing
# Describe "Symbolic Names and Outputs" -Tags 11 {
#     It "" {

#     }
# }

# # Challenge 13 - Convert Existing Resources
# Describe "Symbolic Names and Outputs" -Tags 12 {
#     It "" {

#     }
# }

# # Challenge 14 - Modules and Private Registries
# Describe "Symbolic Names and Outputs" -Tags 13 {
#     It "" {

#     }
# }

# # Challenge 15 - Azure Verified Modules
# Describe "Symbolic Names and Outputs" -Tags 14 {
#     It "" {

#     }
# }