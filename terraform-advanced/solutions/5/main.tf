terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "1.15.0"
    }

  }
}

provider "azurerm" {
  subscription_id                 = "847cb8f3-802b-42ab-aa9b-fe9d17d25580"
  resource_provider_registrations = "none"
  features {}
}

provider "azapi" {

}

resource "azurerm_resource_group" "rg" {
  name     = ""
  location = ""
}


resource "azapi_resource" "container" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01"
  name      = "thumbnails"
  parent_id = "${azurerm_storage_account.stg.id}/blobServices/default"
  body = jsonencode({
    properties = {
    }
  })
}

module "stg" {
  source               = "./modules/terraform-azure-storage-account"
  resource_group_name  = data.azurerm_resource_group.rg.name
  location             = data.azurerm_resource_group.rg.location
  storage_account_name = ""
}

#-----Remove this code
module "stg1" {
  count = 3

  source               = "./modules/terraform-azure-storage-account"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = "st7jralg5kub6sa${count.index + 1}"
}
#-----


#----- Add below code
module "stg1" {
  #count = 3
  for_each = tomap({
    one   = 1
    three = 2
  })


  source               = "./modules/terraform-azure-storage-account"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = "st7jralg5kub6sa${each.value + 1}"
}
#-----
