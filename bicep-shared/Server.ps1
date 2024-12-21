Start-PodeServer {
    # Query using http://PublicIP/tests?Tag=<test tag number>
    # Where the Pester test in C:\Tests is tagged using 
    # -Tag e.g. Describe "Terraform Installation" -Tags 0
    Add-PodeEndpoint -Address * -Port 8080 -Protocol Http
    Add-PodeRoute -Method Get -Path '/tests' -ScriptBlock {
        $Tag = $WebEvent.Query['Tag']
        $Result = $(Invoke-Pester -Path "C:\Tests\" -Tag $($Tag) -PassThru -Output Minimal) | ConvertTo-Json
        Write-Host "Tag: $($Tag)"
        Write-PodeJsonResponse -Value $Result
    }
}