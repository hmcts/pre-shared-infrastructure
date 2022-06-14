locals {
  prefix              = "${var.product}-${var.env}"
  resource_group_name = "${local.prefix}"
  key_vault_name      = "${var.product}-kv-${var.env}"
  env_long_name       = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}



