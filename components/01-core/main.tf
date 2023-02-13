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
  videoedit-subnet    = data.azurerm_subnet.videoedit_subnet.id
  datagateway-subnet  = azurerm_subnet.datagateway_subnet.id
}
