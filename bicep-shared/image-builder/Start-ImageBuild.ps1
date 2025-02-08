Connect-AzAccount -Identity
New-AzResourceGroupDeployment -ResourceGroupName 'rg-aue-imagebuilder' -TemplateFile '.\bicep-shared\image-builder\bicepWorkstationTemplate.bicep'