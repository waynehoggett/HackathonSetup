terraform {
  required_version = "~> 1.9.4"

  backend "azurerm" {
    resource_group_name  = "%RG_NAME%"
    storage_account_name = "%STG_NAME%"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_msi              = true
    subscription_id      = "847cb8f3-802b-42ab-aa9b-fe9d17d25580"
    tenant_id            = "8940c948-d605-4e9a-b426-91153d1275f9"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = "847cb8f3-802b-42ab-aa9b-fe9d17d25580"
  features {}
}

provider "random" {
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

resource "random_string" "stgname" {
  length      = 24
  min_lower   = 12
  min_numeric = 12
}

resource "azurerm_storage_account" "stg" {
  name                     = random_string.stgname.result
  location                 = data.azurerm_resource_group.rg.location
  resource_group_name      = data.azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "ZRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.stg.name
  container_access_type = "private"
}
