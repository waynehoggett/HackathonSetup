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
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
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

provider "random" {
}

locals {
  tags = {
    environment = "hackathon"
    source      = "terraform"
  }
}


resource "azurerm_resource_group" "rg" {
  name     = "%RG_NAME%"
  location = "%RG_LOCATION%"

  tags = local.tags
}

module "stg" {
  source               = "./modules/terraform-azure-storage-account"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = "%STG_NAME%"

  tags = local.tags
}

module "multiplestg" {
  for_each             = toset(["1", "3"])
  source               = "./modules/terraform-azure-storage-account"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_name = "%STG_NAME%${each.key}"

  tags = local.tags
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

import {
  id = "%SQL_RG_ID%"
  to = azurerm_resource_group.sqlrg
}

resource "azurerm_resource_group" "sqlrg" {
  name     = "%SQL_RG_NAME%"
  location = "%SQL_RG_LOCATION%"

  tags = local.tags
}

resource "random_string" "sqlname" {
  length      = 7
  min_lower   = 4
  min_numeric = 3
}

resource "azurerm_mssql_server" "sqlsvr" {
  name                         = "sqlserver${random_string.sqlname.result}"
  resource_group_name          = data.azurerm_resource_group.sqlrg.name
  location                     = data.azurerm_resource_group.sqlrg.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

  tags = local.tags
}

resource "azurerm_mssql_database" "sqldb" {
  name         = "db1"
  server_id    = azurerm_mssql_server.sqlsvr.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

  lifecycle {
    prevent_destroy = true
  }

  tags = local.tags
}
