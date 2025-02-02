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
  scope: resourceGroup('%VNET_RESOURCE_GROUP%')
}

resource ExistingSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: 'Subnet1'
  parent: ExistingVirtualNetwork
}

@batchSize(3)
resource storageaccount 'Microsoft.Storage/storageAccounts@2023-05-01' = [for i in range(1, count): {
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
      defaultAction: 'Deny'
      bypass: 'None'
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: ExistingSubnet.id
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
