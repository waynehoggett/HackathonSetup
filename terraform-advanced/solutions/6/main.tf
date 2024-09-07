terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }
}

provider "azurerm" {
  subscription_id                 = "847cb8f3-802b-42ab-aa9b-fe9d17d25580"
  resource_provider_registrations = "none"
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "rg-sql-a906e245-9669-407b-9263-71125c6284f3"
}

resource "azurerm_mssql_server" "sqlsvr" {
  name                         = "sqlservera906e245"
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = data.azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
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
}
