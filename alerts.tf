data "azurerm_key_vault_secret" "slack_monitoring_address" {
  name         = "slack-monitoring-address"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_application_insights" "this" {
  name                = "pre-${var.env}-appinsights"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "other"
}

module "pre-action-group" {
  # count    = var.env == "prod" ? 1 : 0
  source   = "github.com/hmcts/cnp-module-action-group"
  location = "global"
  env      = var.env

  resourcegroup_name     = data.azurerm_resource_group.rg.name
  action_group_name      = "pre-support"
  short_name             = "pre-support"
  email_receiver_name    = "PRE Support Mailing List"
  email_receiver_address = data.azurerm_key_vault_secret.slack_monitoring_address
}

module "vms-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.this.location
  app_insights_name = azurerm_application_insights.this.name

  alert_name                 = "vms-alert"
  alert_desc                 = "Triggers when a VM exception is received in a 5 minute poll."
  app_insights_query         = "requests | where toint(resultCode) >= 400 | sort by timestamp desc"
  frequency_in_minutes       = 15
  time_window_in_minutes     = 15
  severity_level             = "3"
  action_group_name          = module.pre-action-group.action_group_name
  custom_email_subject       = "Virtual Machine Exception"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = data.azurerm_resource_group.rg.name
  common_tags = var.common_tags
}

