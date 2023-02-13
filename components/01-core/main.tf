module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = var.prefix
  builtFrom   = var.builtFrom
}

locals {
  resource_group_name = "${var.prefix}-${var.env}"
  key_vault_name      = "${var.prefix}-kv-${var.env}"
  env_long_name       = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.id
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.vnet.id
}

data "azurerm_resource_group" "rg" {
  name = "pre-dev"
}

output "id" {
  value = data.azurerm_resource_group.rg.id
}