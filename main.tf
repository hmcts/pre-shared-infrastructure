module "log_analytics_workspace" {
  source      = "git@github.com:hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
}

locals {
  env_long_name = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env

  mgmt_network_name    = var.mgmt_net_name
  mgmt_network_rg_name = var.mgmt_net_rg_name
}

resource "azurerm_role_assignment" "sp_contributor" {
  count                = var.env == "demo" || var.env == "stg" || var.env == "prod" ? 1 : 0
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.pre_sp.object_id
}

# resource "azurerm_role_assignment" "admin_ingestsa_contributor" {
#   scope                = module.ingestsa_storage_account.storageaccount_id
#   role_definition_name = "Storage Account Contributor"
#   principal_id         = var.pre_app_admin
# }

# resource "azurerm_role_assignment" "admin_finalsa_contributor" {
#   scope                = module.finalsa_storage_account.storageaccount_id
#   role_definition_name = "Storage Account Contributor"
#   principal_id         = var.pre_app_admin
# }

# resource "azurerm_role_assignment" "admin_finalsa_data_contributor" {
#   scope                = module.finalsa_storage_account.storageaccount_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = var.pre_app_admin
# }

# resource "azurerm_role_assignment" "admin_ingestsa_data_contributor" {
#   scope                = module.ingestsa_storage_account.storageaccount_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = var.pre_app_admin
# }

# resource "azurerm_role_assignment" "admin_sa_data_contributor" {
#   scope                = module.sa_storage_account.storageaccount_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = var.pre_app_admin
# }


resource "azurerm_automation_account" "pre-aa" {
  name                = "${var.product}-${var.env}-aa"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

data "azurerm_key_vault_secret" "slack_monitoring_address" {
  name         = "slack-monitoring-address"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_application_insights" "this" {
  count               = var.env == "prod" ? 1 : 0
  name                = "pre-${var.env}-appinsights"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "other"
}

resource "azurerm_key_vault_secret" "appinsights-key" {
  count        = var.env == "prod" ? 1 : 0
  name         = "AppInsightsInstrumentationKey"
  value        = azurerm_application_insights.this[0].instrumentation_key
  key_vault_id = data.azurerm_key_vault.keyvault.id

  depends_on = [azurerm_application_insights.this]
}

resource "azurerm_key_vault_secret" "appinsights-non-prod-key" {
  count        = var.env != "prod" ? 1 : 0
  name         = "AppInsightsInstrumentationKey"
  value        = "00000000-0000-0000-0000-000000000000"
  key_vault_id = data.azurerm_key_vault.keyvault.id

  depends_on = [azurerm_application_insights.this]
}

resource "azurerm_monitor_action_group" "pre-support" {
  count               = var.env == "prod" ? 1 : 0
  name                = "CriticalAlertsAction"
  resource_group_name = data.azurerm_resource_group.rg.name
  short_name          = "pre-support"

  email_receiver {
    name          = "PRE Support Mailing List"
    email_address = data.azurerm_key_vault_secret.slack_monitoring_address.value
  }
}