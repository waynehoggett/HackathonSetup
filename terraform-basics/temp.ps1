$vmUsername = $Username
$vmPassword = $PasswordProfile.Password
$guid = $Session.RowKey

$TemplateUri = 'https://raw.githubusercontent.com/waynehoggett/HackathonSetup/main/terraform-basics/main.bicep'
Invoke-WebRequest -Uri $TemplateUri -OutFile main.bicep -UseBasicParsing
New-AzResourceGroupDeployment -ResourceGroupName "$($ResourceGroup.ResourceGroupName)" -Mode Complete -Force -Name (New-Guid) -TemplateFile 'main.bicep' -guid $Guid -vmUsername $vmUsername -vmPassword $vmPassword