terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
    # --- Add this required provider
    azapi = {
      source  = "Azure/azapi"
      version = "1.15.0"
    }
    # --- Add this required provider
  }
}

provider "azurerm" {
  subscription_id                 = "847cb8f3-802b-42ab-aa9b-fe9d17d25580"
  resource_provider_registrations = "none"
  features {}
}
# --- Add this provider config
provider "azapi" {

}
# --- 
import {
  id = ""
  to = azurerm_resource_group.rg
}

import {
  id = ""
  to = azurerm_storage_account.stg
}

resource "azurerm_resource_group" "rg" {
  name     = ""
  location = ""
}

#--- Remove this code
resource "azurerm_storage_account" "stg" {
  name                            = ""
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_0"
  allow_nested_items_to_be_public = "false"
  network_rules {
    default_action = "Deny"
    ip_rules       = []
  }
}
#--- To here


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

#----- Add below code, and add the modules folder
module "stg1" {
  count = 3

  source               = "./modules/terraform-azure-storage-account"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = "st7jralg5kub6sa${count.index + 1}"
}
#-----
