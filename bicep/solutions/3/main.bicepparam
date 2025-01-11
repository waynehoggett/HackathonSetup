using './main.bicep'

param name = 'st${toLower(uniqueString('1'))}'
param skuName = 'Standard_ZRS'
