$Count = 50
$CurrentCount = 34

class Session
{
[string]$HackId
[string]$Hack
[string]$User
[string]$Status
}


while ($CurrentCount -le $Count) {

    try {
        $Session = [Session]::new()
        $Session.HackId = "f38c89bd-e134-456f-b475-ab23bc860be2"
        $Session.Hack = "Bicep"
        $Session.User = "TestUser$($CurrentCount)"
        $Session.Status = "New"

        Invoke-RestMethod https://minicert.com/session/create -Method POST -Body ($Session | ConvertTo-Json)

        $CurrentCount++
        Write-Host "Sleeping for $(30 + $CurrentCount) seconds..."
        Start-Sleep -Seconds (30 + $CurrentCount)
    } catch {
        Write-Host "Failed to start session."
    }   

    
}