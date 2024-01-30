locals {
  env_long_name = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env

  mgmt_network_name    = var.mgmt_net_name
  mgmt_network_rg_name = var.mgmt_net_rg_name
}

module "log_analytics_workspace" {
  source      = "git@github.com:hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
}

resource "azurerm_role_assignment" "sp_contributor" {
  count                = var.env == "demo" || var.env == "stg" || var.env == "prod" ? 1 : 0
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.pre_sp.object_id
}

module "application_insights" {
  count         = var.env == "prod" ? 1 : 0
  source        = "git@github.com:hmcts/terraform-module-application-insights?ref=main"
  env           = var.env
  product       = var.product
  override_name = "pre-${var.env}-appinsights"

  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "other"
  common_tags         = var.common_tags
}

resource "azurerm_key_vault_secret" "appinsights-key" {
  count        = var.env == "prod" ? 1 : 0
  name         = "AppInsightsInstrumentationKey"
  value        = module.application_insights[0].instrumentation_key
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "appinsights-non-prod-key" {
  count        = var.env != "prod" ? 1 : 0
  name         = "AppInsightsInstrumentationKey"
  value        = "00000000-0000-0000-0000-000000000000"
  key_vault_id = data.azurerm_key_vault.keyvault.id

  depends_on = [module.application_insights]
}

resource "azurerm_key_vault_secret" "appinsights_connection_string" {
  count        = var.env == "prod" ? 1 : 0
  name         = "app-insights-connection-string"
  value        = module.application_insights[0].connection_string
  key_vault_id = data.azurerm_key_vault.keyvault.id
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
