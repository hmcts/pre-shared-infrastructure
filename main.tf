locals {
  prefix              = "${var.product}-rg2-${var.env}"
  resource_group_name = "${local.prefix}"
  key_vault_name      = "${var.product}-kv2-${var.env}"
  env_long_name       = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

# module "kv" {
#   source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
#   name                    = local.key_vault_name
#   product                 = var.product
#   env                     = var.env
#   object_id               = "7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01"
#   resource_group_name     = azurerm_resource_group.rg.name
#   product_group_name      = var.active_directory_group
#   common_tags             = var.common_tags
#   create_managed_identity = false
# }

