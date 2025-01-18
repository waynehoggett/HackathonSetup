param name string = toLower(uniqueString(resourceGroup().id))
param location string = resourceGroup().location
param skuName string = 'Standard_LRS'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: name
  location: location
  kind: 'StorageV2'
  sku: {
    name: skuName
  }
}
