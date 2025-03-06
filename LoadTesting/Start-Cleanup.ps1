Connect-AzAccount -Identity
Set-AzContext -Subscription "VSE"

$Sessions = Invoke-RestMethod https://minicert.com/session/list -Method GET -ContentType "text/plain"
foreach ($Session in $Sessions) {
    if ($Session.LabResourceGroupName) {
        if (Get-AzResourceGroup -Name $Session.LabResourceGroupName -ErrorAction SilentlyContinue) {
            Write-Host "Removing $($Session.LabResourceGroupName)"
            Remove-AzResourceGroup -Name $Session.LabResourceGroupName -Force -ErrorAction SilentlyContinue
        }
    }
    if ($Session.ResourceGroupName) {
        if (Get-AzResourceGroup -Name $Session.ResourceGroupName -ErrorAction SilentlyContinue) {
            Write-Host "Removing $($Session.ResourceGroupName)"
            Remove-AzResourceGroup -Name $Session.ResourceGroupName -Force -ErrorAction SilentlyContinue
        }
    }
    if ($Session.SQLLabResourceGroupName) {
        if (Get-AzResourceGroup -Name $Session.SQLLabResourceGroupName -ErrorAction SilentlyContinue) {
            Write-Host "Removing $($Session.SQLLabResourceGroupName)"
            Remove-AzResourceGroup -Name $Session.SQLLabResourceGroupName -Force -ErrorAction SilentlyContinue
        }
    }
    if ($Session.StorageLabResourceGroupName) {
        if (Get-AzResourceGroup -Name $Session.StorageLabResourceGroupName -ErrorAction SilentlyContinue) {
            Write-Host "Removing $($Session.StorageLabResourceGroupName)"
            Remove-AzResourceGroup -Name $Session.StorageLabResourceGroupName -Force -ErrorAction SilentlyContinue
        }
    }
    if ($Session.VnetLabResourceGroupName) {
        if (Get-AzResourceGroup -Name $Session.VnetLabResourceGroupName -ErrorAction SilentlyContinue) {
            Write-Host "Removing $($Session.VnetLabResourceGroupName)"
            Remove-AzResourceGroup -Name $Session.VnetLabResourceGroupName -Force -ErrorAction SilentlyContinue
        }
    }
}