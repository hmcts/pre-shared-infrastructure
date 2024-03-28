locals {
  env_long_name = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env

  mgmt_network_name    = var.mgmt_net_name
  mgmt_network_rg_name = var.mgmt_net_rg_name

  # asset files from https://github.com/alphagov/govuk-frontend/releases/latest
  # command to generate the list of files:
  # cd b2c/views && find . -type f | sed 's/^.\///' | sed 's/.*/"&",/'
  # when updating the gds frontend version:
  # update release version in the template.html file
  # correct the `url()` paths in the minified css file
  # correct the `src` paths in the manifest.json file

  b2c_files = [
    templatefile("b2c/views/template.html", {
      env           = var.env
      env_long_name = local.env_long_name
    }),
    templatefile("b2c/views/css/main.css", {
      env           = var.env
      env_long_name = local.env_long_name
    }),
    templatefile("b2c/views/css/govuk-frontend-5.2.0.min.css", {
      env           = var.env
      env_long_name = local.env_long_name
    }),
    templatefile("b2c/views/js/b2c.js", {
      env           = var.env
      env_long_name = local.env_long_name
    }),
    "template.html",
    "css/main.css",
    "css/govuk-frontend-5.2.0.min.css",
    "css/govuk-frontend-5.2.0.min.css.map",
    "js/govuk-frontend-5.2.0.min.js.map",
    "js/govuk-frontend-5.2.0.min.js",
    "assets/images/govuk-crest.png",
    "assets/images/favicon.ico",
    "assets/images/govuk-icon-180.png",
    "assets/images/govuk-icon-192.png",
    "assets/images/govuk-icon-mask.svg",
    "assets/images/govuk-crest-2x.png",
    "assets/images/govuk-opengraph-image.png",
    "assets/images/govuk-icon-512.png",
    "assets/images/favicon.svg",
    "assets/manifest.json",
    "assets/fonts/bold-b542beb274-v2.woff2",
    "assets/fonts/light-f591b13f7d-v2.woff",
    "assets/fonts/light-94a07e06a1-v2.woff2",
    "assets/fonts/bold-affa96571d-v2.woff",
    "js/b2c.js"
  ]
  b2c_container_name = "${var.product}-b2c-container"
  containers = [{
    name        = local.b2c_container_name
    access_type = "container"
  }]
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
  name         = "AppInsightsInstrumentationKey"
  value        = module.application_insights.instrumentation_key
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "appinsights_connection_string" {
  name         = "app-insights-connection-string"
  value        = module.application_insights.connection_string
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
