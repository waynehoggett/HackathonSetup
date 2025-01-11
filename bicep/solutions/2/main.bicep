resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: uniqueString(resourceGroup().id)
  location: 'australiaeast'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
