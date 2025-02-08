Install-Module Az.ImageBuilder -Force
Connect-AzAccount -Identity
$ResourceGroupName = 'rg-aue-imagebuilder'
$ImageName = 'BicepTemplate'
# Update/Upgrade of image templates is currently not supported, so remove the existing template before deploying the new one
Get-AzImageBuilderTemplate -ResourceGroupName $ResourceGroupName -ImageTemplateName $ImageName | Remove-AzImageBuilderTemplate
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile '.\bicep-shared\image-builder\bicepWorkstationTemplate.bicep'