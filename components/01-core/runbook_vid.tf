resource "azurerm_automation_account" "pre-aa" {
  name                = "${var.prefix}-${var.env}-aa"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.id
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = module.tags.common_tags
}