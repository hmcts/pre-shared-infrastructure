data "azurerm_resource_group" "rg" {
  name = "${var.product}-${var.env}"
}

data "azuread_application" "appreg" {
  display_name = "dts_pre_${var.env}"
}

resource "azurerm_service_plan" "this" {
  count               = var.create_service_plan ? 1 : 0
  name                = "${var.product}-asp-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type #"Windows"
  sku_name            = "Y1"
  # zone_balancing_enabled = true

  tags = var.common_tags
}

resource "azurerm_windows_function_app" "this" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                = "${var.name}-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key
  service_plan_id            = azurerm_service_plan.this[0].id

  app_settings = var.app_settings
  https_only   = true

  tags = var.common_tags

  site_config {
    application_insights_connection_string = "InstrumentationKey=${azurerm_application_insights.appinsight.instrumentation_key};IngestionEndpoint=https://uksouth-0.in.applicationinsights.azure.com/"
  }

  identity {
    type = "SystemAssigned"
  }

  # auth_settings {
  # enabled                       = true
  # unauthenticated_client_action = "RedirectToLoginPage"
  # default_provider              = "AzureActiveDirectory"
  # issuer                        = "https://sts.windows.net/531ff96d-0ae9-462a-8d2d-bec7c0b42082/"
  # active_directory {
  #   client_id = data.azuread_application.appreg.application_id
  # }
  # }
}

resource "azurerm_linux_function_app" "this" {
  count               = var.os_type == "Linux" ? 1 : 0
  name                = "${var.name}-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key

  service_plan_id = azurerm_service_plan.this[0].id

  app_settings = var.app_settings
  https_only   = true

  tags = var.common_tags

  site_config {
    application_insights_connection_string = "InstrumentationKey=${azurerm_application_insights.appinsight.instrumentation_key};IngestionEndpoint=https://uksouth-0.in.applicationinsights.azure.com/"
    application_stack {
      node_version = "18"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  # auth_settings {
  # enabled                       = true
  # unauthenticated_client_action = "RedirectToLoginPage"
  # default_provider              = "AzureActiveDirectory"
  # issuer                        = "https://sts.windows.net/531ff96d-0ae9-462a-8d2d-bec7c0b42082/"
  # active_directory {
  #   client_id = data.azuread_application.appreg.application_id
  # }
  # }
}

resource "azurerm_storage_account" "this" {
  name                            = replace("${var.name}${var.env}", "-", "")
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  tags                            = var.common_tags
  allow_nested_items_to_be_public = false
}

resource "azurerm_application_insights" "appinsight" {
  application_type    = "web"
  location            = var.location
  name                = "${var.product}-${var.name}-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = var.common_tags
}