data "azurerm_key_vault_secret" "slack_monitoring_address" {
  name         = "slack-monitoring-address"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_application_insights" "this" {
  count               = var.env == "prod" || var.env == "sbox" ? 1 : 0
  name                = "pre-${var.env}-appinsights"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "other"
}

resource "azurerm_monitor_action_group" "pre-support" {
  count               = var.env == "prod" || var.env == "sbox" ? 1 : 0
  name                = "CriticalAlertsAction"
  resource_group_name = data.azurerm_resource_group.rg.name
  short_name          = "pre-support"

  email_receiver {
    name          = "PRE Support Mailing List"
    email_address = data.azurerm_key_vault_secret.slack_monitoring_address.value
  }
}