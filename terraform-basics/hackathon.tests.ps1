# Pester test script
Describe "Terraform Installation" -Tags 0 {
    It "should have Terraform installed" {
        # Check if terraform command is available
        $terraformPath = Get-Command terraform -ErrorAction SilentlyContinue
        $terraformPath | Should -Not -BeNullOrEmpty
    }
}