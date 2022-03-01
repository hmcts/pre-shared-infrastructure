resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-2-${var.env}"
  location = var.location
  tags     = var.common_tags
}
