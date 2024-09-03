terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = "847cb8f3-802b-42ab-aa9b-fe9d17d25580"
  resource_provider_registrations = "none"
}

data "azurerm_resource_group" "rg" {
  name = "rg-stg-f30e67f5-d868-465e-86d5-0766d9b9fae6"
}

module "stg" {
  source               = "./modules/terraform-azure-storage-account"
  resource_group_name  = data.azurerm_resource_group.rg.name
  location             = data.azurerm_resource_group.rg.location
  storage_account_name = "st66mk4djpk2hde"
}
