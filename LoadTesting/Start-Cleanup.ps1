Connect-AzAccount -Identity
Set-AzContext -Subscription "VSE"


$Sessions = Invoke-RestMethod https://minicert.com/session/list -Method GET -ContentType "text/plain"
foreach ($Session in $Sessions) {
    $Session
    if ($Session.LabResourceGroupName) {
        if (Get-AzResourceGroup -Name $Session.LabResourceGroupName) {
            Remove-AzResourceGroup -Name $Session.LabResourceGroupName -Force -ErrorAction SilentlyContinue
        }
    }
    if ($Session.ResourceGroupName) {
        if (Get-AzResourceGroup -Name $Session.ResourceGroupName) {
            Remove-AzResourceGroup -Name $Session.ResourceGroupName -Force -ErrorAction SilentlyContinue
        }
    }
    if ($Session.SQLLabResourceGroupName) {
        if (Get-AzResourceGroup -Name $Session.SQLLabResourceGroupName) {
            Remove-AzResourceGroup -Name $Session.SQLLabResourceGroupName -Force -ErrorAction SilentlyContinue
        }
    }
    if ($Session.StorageLabResourceGroupName) {
        if (Get-AzResourceGroup -Name $Session.StorageLabResourceGroupName) {
            Remove-AzResourceGroup -Name $Session.StorageLabResourceGroupName -Force -ErrorAction SilentlyContinue
        }
    }
    if ($Session.VnetLabResourceGroupName) {
        if (Get-AzResourceGroup -Name $Session.VnetLabResourceGroupName) {
            Remove-AzResourceGroup -Name $Session.VnetLabResourceGroupName -Force -ErrorAction SilentlyContinue
        }
    }
}
