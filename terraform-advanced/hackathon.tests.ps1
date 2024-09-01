# Pester test script
Describe " Install Software and VS Code Extensions" -Tags 0 {
    It "Should have Azure CLI installed" {
        $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
        Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
        Update-SessionEnvironment
        $azpath = Get-Command az -ErrorAction SilentlyContinue
        $azpath | Should -Not -BeNullOrEmpty
    }
}
