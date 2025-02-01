@maxValue(9)
param count int = 1

param location string = 'australiaeast'
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param skuName string = 'Standard_LRS'

@batchSize(3)
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = [for i in range(1, count): {
  name: 'st${uniqueString(resourceGroup().id)}${i}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: skuName
  }
}]

output storageAccountNames array = [for index in range(0, count): {
  name: storageaccount[index].name
}]

output blobServiceUris array = [for index in range(0, count): {
  uri: storageaccount[index].properties.primaryEndpoints.blob
}]
