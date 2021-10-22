provider azurerm {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location

  tags = var.common_tags
}

module "key-vault" {
  source              = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  product             = var.product
  env                 = var.env
  tenant_id           = var.tenant_id
  object_id           = var.jenkins_AAD_objectId
  resource_group_name = azurerm_resource_group.rg.name

  # dcd_platformengineering group object ID
  product_group_name = "dcd_divorce"
  common_tags                = var.common_tags
  create_managed_identity    = true
}

resource "azurerm_key_vault_secret" "AZURE_APPINSIGHTS_KEY" {
  name         = "AppInsightsInstrumentationKey"
  value        = azurerm_application_insights.appinsights.instrumentation_key
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${var.product}-appinsights-${var.env}"
  location            = var.appinsights_location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"

  tags = var.common_tags

  lifecycle {
    ignore_changes = [
      # Ignore changes to appinsights as otherwise upgrading to the Azure provider 2.x
      # destroys and re-creates this appinsights instance..
      application_type,
    ]
  }
}

resource "azurerm_key_vault_secret" "AZURE_APPINSIGHTS_KEY_PREVIEW" {
  name         = "AppInsightsInstrumentationKey-Preview"
  value        = azurerm_application_insights.appinsights_preview[0].instrumentation_key
  key_vault_id = module.key-vault.key_vault_id
  count = var.env == "aat" ? 1 : 0
}

resource "azurerm_application_insights" "appinsights_preview" {
  name                = "${var.product}-appinsights-preview"
  location            = var.appinsights_location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  count = var.env == "aat" ? 1 : 0

  tags = var.common_tags

  lifecycle {
    ignore_changes = [
      # Ignore changes to appinsights as otherwise upgrading to the Azure provider 2.x
      # destroys and re-creates this appinsights instance..
      application_type,
    ]
  }
}



resource "azurerm_application_insights_web_test" "appinsights-2" {
  name = "nfdiv-webtest"
  location = var.appinsights_location
  resource_group_name = azurerm_resource_group.rg.name
  application_insights_id = azurerm_application_insights.appinsights.id
  kind = "ping"
  frequency = 300
  timeout = 60
  enabled = true
  retry_enabled = true
  geo_locations = [
    "emea-se-sto-edge",
    "apac-sg-sin-azr",
    "us-il-ch1-azr",
    "emea-gb-db3-azr",
    "emea-ru-msa-edge"]

  configuration = "<WebTest Name=\"manual1-dg\" Id=\"2723c2f5-fa3a-4ac2-832c-8444bd8f8da5\" Enabled=\"True\"   CssProjectStructure=\"\"         CssIteration=\"\"         Timeout=\"120\"         WorkItemIds=\"\"         xmlns=\"http://microsoft.com/schemas/VisualStudio/TeamTest/2010\"         Description=\"\"         CredentialUserName=\"\"         CredentialPassword=\"\"         PreAuthenticate=\"True\"         Proxy=\"default\"         StopOnError=\"False\"         RecordedResultFile=\"\"         ResultsLocale=\"\">        <Items>        <Request         Method=\"GET\"         Guid=\"a5eb315b-d699-bdd6-e527-43120955cb86\"         Version=\"1.1\"         Url=\"http://www.google.com\"         ThinkTime=\"0\"         Timeout=\"120\"         ParseDependentRequests=\"False\"         FollowRedirects=\"True\"         RecordResult=\"True\"         Cache=\"False\"         ResponseTimeGoal=\"0\"         Encoding=\"utf-8\"         ExpectedHttpStatusCode=\"200\"         ExpectedResponseUrl=\"\"         ReportingName=\"\"         IgnoreHttpStatusCode=\"False\" />        </Items>        </WebTest>"
  count = var.custom_alerts_enabled ? 1 : 0
}
