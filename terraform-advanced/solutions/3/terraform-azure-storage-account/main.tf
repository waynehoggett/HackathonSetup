resource "azurerm_storage_account" "stg" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_0"
  allow_nested_items_to_be_public = "false"
  network_rules {
    default_action = "Deny"
    ip_rules       = []
  }
}
