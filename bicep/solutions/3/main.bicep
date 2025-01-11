param storageAccountName string
param location string = resourceGroup().location
@allowed([
'Premium_LRS'
'Premium_ZRS'
'Standard_GRS'
'Standard_GZRS'
'Standard_LRS'
'Standard_RAGRS'
'Standard_RAGZRS'
'Standard_ZRS'
])
param skuName string = 'Standard_LRS'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: skuName
  }
}
