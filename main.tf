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

# resource "azurerm_role_assignment" "pre_reader_mi" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Reader"
#   principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id # var.pre_mi_principal_id
#   skip_service_principal_aad_check = true
# }

# Give PowerApp Appreg contributor access to resource groups
# resource "azurerm_role_assignment" "powerapp_appreg" {
#   scope                = azurerm_resource_group.rg.id
#   role_definition_name = "Contributor"
#   principal_id         = var.dts_pre_ent_appreg_oid
# }
