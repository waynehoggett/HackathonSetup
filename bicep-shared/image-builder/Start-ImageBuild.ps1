Install-Module Az.ImageBuilder -Force
Connect-AzAccount -Identity
$ResourceGroupName = 'rg-aue-imagebuilder'
$ImageName = 'BicepTemplate'
# Remove existing role assignment
Get-AzRoleAssignment -ResourceGroupName $ResourceGroupName -RoleDefinitionName '64134e33-738a-55dc-a976-e7b7fe01701d' | Remove-AzRoleAssignment -ErrorAction SilentlyContinue
# Update/Upgrade of image templates is currently not supported, so remove the existing template before deploying the new one
Get-AzImageBuilderTemplate -ResourceGroupName $ResourceGroupName -ImageTemplateName $ImageName | Remove-AzImageBuilderTemplate -ErrorAction SilentlyContinue
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile '.\bicep-shared\image-builder\bicepWorkstationTemplate.bicep'