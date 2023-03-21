module "log_analytics_workspace" {
  source      = "git@github.com:hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
}

locals {
  env_long_name = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env

  mgmt_network_name    = var.mgmt_net_name
  mgmt_network_rg_name = var.mgmt_net_rg_name
}

# resource "azurerm_role_assignment" "pre_reader_mi" {
#   scope                            = data.azurerm_resource_group.rg.id
#   role_definition_name             = "Reader"
#   principal_id                     = data.azurerm_user_assigned_identity.managed_identity.principal_id # var.pre_mi_principal_id 
#   skip_service_principal_aad_check = true
# }

# resource "azurerm_role_assignment" "vm_user_mi" {
#   scope                            = data.azurerm_resource_group.rg.id
#   role_definition_name             = "Virtual Machine Contributor"
#   principal_id                     = data.azurerm_user_assigned_identity.managed_identity.principal_id # var.pre_mi_principal_id 
#   skip_service_principal_aad_check = true
# }

# # Give PowerApp Appreg contributor access to resource groups
# resource "azurerm_role_assignment" "powerapp_appreg" {
#   scope                = data.azurerm_resource_group.rg.id
#   role_definition_name = "Contributor"
#   principal_id         = var.dts_pre_ent_appreg_oid
# }

# DTS-PRE-VideoEditing-SecurityGroup-
# resource "azurerm_role_assignment" "vmuser_login" {
#   for_each             = toset(data.azuread_groups.groups.object_ids)
#   scope                = data.azurerm_resource_group.rg.id
#   role_definition_name = "Virtual Machine User Login"
#   principal_id         = each.value
# }

# "Contributor", "Storage Blob Data Contributor", and "User Access Administrator"

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

resource "azurerm_role_assignment" "pre_developer" {
  scope                = module.ams_function_app.function_app_id
  role_definition_name = "Application Developer"
  principal_id         = "ffaee209-2441-499a-8d12-c38b20ec67cb"
}

resource "azurerm_role_assignment" "pre_admin" {
  scope                = module.ams_function_app.function_app_id #data.azurerm_resource_group.rg.id #azurerm_media_services_account.ams.id
  role_definition_name = "Power Platform Administrator"
  principal_id         = "ffaee209-2441-499a-8d12-c38b20ec67cb"
}

# Application Developer
# Power Platform Administrator
# User Administrator

# resource "azurerm_role_assignment" "kv-mi" {
#   scope                = module.sa_storage_account.storageaccount_id
#   role_definition_name = "Storage Account Key Operator Service Role"
#   principal_id         = data.azuread_service_principal.kv.id
# }
