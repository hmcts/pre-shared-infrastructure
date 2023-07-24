module "log_analytics_workspace" {
  source      = "git@github.com:hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
}

locals {
  env_long_name = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env

  mgmt_network_name    = var.mgmt_net_name
  mgmt_network_rg_name = var.mgmt_net_rg_name
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_role_assignment" "admin_finalsa_data_contributor" {
  scope                = module.finalsa_storage_account.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.pre_app_admin
}

resource "azurerm_role_assignment" "admin_ingestsa_data_contributor" {
  scope                = module.ingestsa_storage_account.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.pre_app_admin
}

resource "azurerm_role_assignment" "admin_sa_data_contributor" {
  scope                = module.sa_storage_account.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.pre_app_admin
}


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
