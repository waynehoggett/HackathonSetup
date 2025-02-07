$Sessions = Invoke-RestMethod https://minicert.com/session/list -Method GET -ContentType "text/plain"
foreach ($Session in $Sessions) {
    $RowKey = $Session.RowKey
    if ($Session.Status -eq "Ready") {
        Invoke-RestMethod https://minicert.com/session/complete -Method POST -Body "$($RowKey)" -ContentType "text/plain"
        Write-Host "Completed session $RowKey. Sleeping for 30 seconds..."
        Start-Sleep -Seconds 30
    }
}
