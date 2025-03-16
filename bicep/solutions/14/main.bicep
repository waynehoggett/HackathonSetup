type storageAccountConfigType = {
  name: string?
  location: string?
  dataConfidentialityLevel: null | 'OFFICIAL' | 'SENSITIVE' | 'PROTECTED'
  skuName: null | 'Standard_LRS' | 'Standard_GRS' | 'Standard_RAGRS' | 'Standard_ZRS' | 'Premium_LRS'
}

param storageAccounts storageAccountConfigType[]

var location  = resourceGroup().location

resource ExistingVirtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' existing =  {
  name: 'VNet1'
  dependsOn: [
    VirtualNetwork
  ]
  scope: resourceGroup('%VNET_RESOURCE_GROUP%')
}

resource ExistingSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: 'Subnet1'
  dependsOn: [
    VirtualNetwork
  ]
  parent: ExistingVirtualNetwork
}

module VirtualNetwork 'br/public:avm/res/network/virtual-network:0.5.2' = {
  name: 'VNet1'
  scope: resourceGroup('%VNET_RESOURCE_GROUP%')
  params: {
    name: 'VNet1'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'Subnet1'
        addressPrefix: '10.0.0.0/24'
        serviceEndpoints: [
          'Microsoft.Storage'
        ]
      }
      {
        name: 'Subnet2'
        addressPrefix: '10.0.1.0/24'
      }
    ]
  }
}

@batchSize(3)
resource storageaccount 'Microsoft.Storage/storageAccounts@2023-05-01' = [for (storageAccount, i) in storageAccounts: {
  name: storageAccount.?name ?? 'st${uniqueString(resourceGroup().id)}${i}'
  location: storageAccount.?location ?? location
  kind: 'StorageV2'
  sku: {
    name: storageAccount.?skuName ?? 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: storageAccount.?dataConfidentialityLevel == 'SENSITIVE' ? false : null
    supportsHttpsTrafficOnly: (storageAccount.?dataConfidentialityLevel == 'SENSITIVE' || storageAccount.?dataConfidentialityLevel == 'PROTECTED') ? true : null
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
    dataConfidentialityLevel: storageAccount.?dataConfidentialityLevel ?? 'SENSITIVE'
  }
}]

