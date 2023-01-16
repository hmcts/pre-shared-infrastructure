resource "azurerm_automation_account" "pre-aa" {
  name                = "${var.product}-${var.env}-aa"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}