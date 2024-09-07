param guid string = newGuid()
param basDnsPrefix string = 'bas${uniqueString(guid)}'
param dnsPrefix string = 'hack${uniqueString(guid)}'
param location string = resourceGroup().location
param virtualNetworkName string = 'vnet-${uniqueString(guid)}'
param vmName string = 'vm${uniqueString(guid)}'
param vmSize string = 'Standard_F4s_v2' // Alternate sizes: Standard_D2_v3, Standard_D2_v4
param vmUsername string = 'Hackathon'
#disable-next-line secure-secrets-in-params
param vmPassword string = 'Password!${uniqueString(guid)}'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  #disable-next-line use-stable-resource-identifiers
  name: 'vnet-australiaeast-connectivity'
  scope: resourceGroup('rg-australiaeast-connectivity')
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  #disable-next-line use-stable-resource-identifiers
  name: 'pip1-${vmName}'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: dnsPrefix
    }
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  #disable-next-line use-stable-resource-identifiers
  name: 'nic1-${vmName}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1-nic1-${vmName}'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  #disable-next-line use-stable-resource-identifiers
  name: vmName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: vmUsername
      adminPassword: vmPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'Windows-11'
        sku: 'win11-22h2-pron'
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk-${vmName}'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

resource windowsVMExtensions 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  parent: virtualMachine
  #disable-next-line use-stable-resource-identifiers
  name: 'cse-${vmName}'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-basics/Setup-Workstation.ps1'
      ]
    }
    protectedSettings: {
      commandToExecute: 'Powershell -ExecutionPolicy Bypass -File Setup-Workstation.ps1'
    }
  }
}

output IPAddress string = publicIP.properties.ipAddress
output vmName string = vmName
output DNSName string = publicIP.properties.dnsSettings.fqdn
output username string = vmUsername
#disable-next-line outputs-should-not-contain-secrets
output password string = vmPassword
