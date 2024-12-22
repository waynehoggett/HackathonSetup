# Pester test script
Describe " Install Software and VS Code Extensions" -Tags 0 {
    It "Should have Azure CLI or Azure PowerShell installed" {
        $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
        Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
        Update-SessionEnvironment
        $azcli = Get-Command az -ErrorAction SilentlyContinue
        $azpsmodule = Get-Module Az -ListAvailable 
        $azcli -or $azpsmodule | Should -Not -BeNullOrEmpty
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