locals {
  prefix              = "${var.product}-${var.env}"
  resource_group_name = local.prefix
  key_vault_name      = "${var.product}-kv-${var.env}"
  env_long_name       = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env

  mgmt_network_name    = var.mgmt_net_name
  mgmt_network_rg_name = var.mgmt_net_rg_name
}

module "log_analytics_workspace" {
  source      = "git@github.com:hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

#Give PowerApp Appreg contributor access to resource groups
resource "azurerm_role_assignment" "powerapp_appreg" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = var.dts_pre_ent_appreg_oid
}
