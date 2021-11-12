resource "azurerm_storage_account" "sa" {
  name                     = "${var.product}sa${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_replication_type
}

resource "azurerm_media_services_account" "ams" {
  name                = "${var.product}ams${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  storage_account {
    id         = azurerm_storage_account.sa.id
    is_primary = true
  }
}
