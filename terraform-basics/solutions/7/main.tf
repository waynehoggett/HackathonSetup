terraform {
  required_version = "~> 1.9.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = "847cb8f3-802b-42ab-aa9b-fe9d17d25580"
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "%RG_NAME%"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.1.0.0/24"]
  }
}
