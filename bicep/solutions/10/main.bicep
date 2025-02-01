@maxValue(9)
param count int = 1

@allowed([
  'OFFICIAL'
  'SENSITIVE'
  'PROTECTED'
])
param dataConfidentialityLevel string = 'PROTECTED'

param location string = 'australiaeast'
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param skuName string = 'Standard_LRS'

resource ExistingVirtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' existing =  {
  name: 'VNet1'
  scope: resourceGroup('rg-lab-1233ac9f-0902-40a7-a8e5-47a8c0e2a668')
}


@batchSize(3)
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = [for i in range(1, count): {
  name: 'st${uniqueString(resourceGroup().id)}${i}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: skuName
  }
  properties: {
    allowBlobPublicAccess: dataConfidentialityLevel == 'SENSITIVE' ? false : null
    supportsHttpsTrafficOnly: (dataConfidentialityLevel == 'SENSITIVE' || dataConfidentialityLevel == 'PROTECTED') ? true : null
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: ExistingVirtualNetwork.id
          action: 'Allow'
        }
      ]
    }
  }
  tags: {
    dataConfidentialityLevel: dataConfidentialityLevel
  }
}]

output storageAccountNames array = [for index in range(0, count): {
  name: storageaccount[index].name
}]

output blobServiceUris array = [for index in range(0, count): {
  uri: storageaccount[index].properties.primaryEndpoints.blob
}]
