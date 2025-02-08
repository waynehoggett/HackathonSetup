param location string = resourceGroup().location
param managedIdentityName string = 'umi-aue-imagebuilder'
param imageGalleryName string = 'gal_aue_hackathon'
param imageDefinitionProperties object = {
  name: 'BicepWorkstation'
  publisher: 'MicrosoftWindowsDesktop'
  offer: 'Windows-11'
  sku: 'win11-24h2-ent'
  version: 'latest'
}
param vmSize string = 'Standard_F4s_v2'
param imageTemplateName string = 'BicepTemplate'
param runOutputName string = 'BicepTemplate_CustomImage'
param replicationRegions array = [
  'australiaeast'
]
param forceUpdateTag string = newGuid()
param scriptUri string = 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/bicep/Set-WorkstationImage.ps1'


resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

resource templateIdentityRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(resourceGroup().id)
  properties: {
    roleName: guid(resourceGroup().id)
    description: 'Used for AIB template and ARM deployment script that runs AIB build'
    type: 'customRole'
    permissions: [
      {
        actions: [
          'Microsoft.Compute/galleries/read'
          'Microsoft.Compute/galleries/images/read'
          'Microsoft.Compute/galleries/images/versions/read'
          'Microsoft.Compute/galleries/images/versions/write'
          'Microsoft.Compute/images/read'
          'Microsoft.Compute/images/write'
          'Microsoft.Compute/images/delete'
          'Microsoft.Storage/storageAccounts/blobServices/containers/read'
          'Microsoft.Storage/storageAccounts/blobServices/containers/write'
          'Microsoft.ContainerInstance/containerGroups/read'
          'Microsoft.ContainerInstance/containerGroups/write'
          'Microsoft.ContainerInstance/containerGroups/start/action'
          'Microsoft.Resources/deployments/read'
          'Microsoft.Resources/deploymentScripts/read'
          'Microsoft.Resources/deploymentScripts/write'
          'Microsoft.VirtualMachineImages/imageTemplates/run/action'
        ]
      }
    ]
    assignableScopes: [
      resourceGroup().id
    ]
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'templateRoleAssignment')
  properties: {
    roleDefinitionId: templateIdentityRoleDefinition.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource imageGallery 'Microsoft.Compute/galleries@2022-03-03' = {
  name: imageGalleryName
  location: location
  properties: {}
}

resource imageDefinition 'Microsoft.Compute/galleries/images@2022-03-03' = {
  parent: imageGallery
  name: imageDefinitionProperties.name
  location: location
  properties: {
    osType: 'Windows'
    osState: 'Generalized'
    identifier: {
      publisher: imageDefinitionProperties.publisher
      offer: imageDefinitionProperties.offer
      sku: imageDefinitionProperties.sku
    }
    recommended: {
      vCPUs: {
        min: 2
        max: 8
      }
      memory: {
        min: 16
        max: 48
      }
    }
    hyperVGeneration: 'V2'
  }
}

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2022-02-14' = {
  name: imageTemplateName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 120
    vmProfile: {
      vmSize: vmSize
      osDiskSizeGB: 127
    }
    source: {
      type: 'PlatformImage'
      publisher: imageDefinitionProperties.publisher
      offer: imageDefinitionProperties.offer
      sku: imageDefinitionProperties.sku
      version: imageDefinitionProperties.version
    }
    customize: [
      {
        type: 'PowerShell'
        name: 'Set-WorkstationImage'
        runElevated: true
        runAsSystem: true
        scriptUri: scriptUri
      }
    ]
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: imageDefinition.id
        runOutputName: runOutputName
        replicationRegions: replicationRegions
      }
    ]
  }
}

resource imageTemplateBuild 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'Image_template_build'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  dependsOn: [
    imageTemplate
    roleAssignment
  ]
  properties: {
    forceUpdateTag: forceUpdateTag
    azPowerShellVersion: '6.2'
    scriptContent: 'Invoke-AzResourceAction -ResourceName "${imageTemplateName}" -ResourceGroupName "${resourceGroup().name}" -ResourceType "Microsoft.VirtualMachineImages/imageTemplates" -ApiVersion "2020-02-14" -Action Run -Force'
    timeout: 'PT1H'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}
