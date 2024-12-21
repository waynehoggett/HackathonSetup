param basDnsPrefix string = 'bas-australiaeast-connectivity'
param location string = 'australiaeast'
param virtualNetworkName string = 'vnet-australiaeast-connectivity'

resource bastionPublicIP 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'pip1-bastion'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: basDnsPrefix
    }
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2024-01-01' = {
  name: 'bas-aue-connectivity'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    enableShareableLink: true
    ipConfigurations: [
      {
        name: 'bastion-ipconfig'
        properties: {
          publicIPAddress: {
            id: bastionPublicIP.id
          }
          subnet: {
            id: virtualNetwork.properties.subnets[1].id
          }
        }
      }
    ]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-snet-workstations'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          description: 'AllowRemoteDesktopProtocol'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowHTTP8080'
        properties: {
          description: 'AllowHTTP'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '8080'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 200
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-workstations'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}
