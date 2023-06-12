module "log_analytics_workspace" {
  source      = "git@github.com:hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
}

locals {
  prefix                     = "${var.product}-${var.env}"
  resource_group_name        = local.prefix
  prefix_backup              = "${var.product}-${var.env}-backup"
  resource_group_name_backup = local.prefix_backup
  key_vault_name             = "${var.product}-kv-${var.env}"
  env_long_name              = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env

  mgmt_network_name    = var.mgmt_net_name
  mgmt_network_rg_name = var.mgmt_net_rg_name
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_resource_group" "rg_backup" {
  name     = local.resource_group_name_backup
  location = var.location_backup
  tags     = var.common_tags
}
