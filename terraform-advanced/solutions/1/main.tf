terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  subscription_id                 = "847cb8f3-802b-42ab-aa9b-fe9d17d25580"
  resource_provider_registrations = "none"
  features {}
}

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
