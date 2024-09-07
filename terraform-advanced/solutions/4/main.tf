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

provider "azapi" {

}

provider "azurerm" {
  subscription_id                 = "847cb8f3-802b-42ab-aa9b-fe9d17d25580"
  resource_provider_registrations = "none"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-stg-d0afad46-398c-4aad-a7be-71e237fd5fca"
  location = "australiaeast"
}


module "stg" {
  source               = "./modules/terraform-azure-storage-account"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = "stbbfhmoafv2z32"
}

module "multiplestg" {
  count                = 3
  source               = "./modules/terraform-azure-storage-account"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = "stbbfhmoafv2z32${count.index + 1}"
}


resource "azapi_resource" "container" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01"
  name      = "thumbnails"
  parent_id = "${module.stg.resource_id}/blobServices/default"
  body = jsonencode({
    properties = {
    }
  })
}

