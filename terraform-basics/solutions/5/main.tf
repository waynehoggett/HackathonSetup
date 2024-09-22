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
