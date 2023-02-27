#Storage Blob Data Contributor Role Assignment for Managed Identity
resource "azurerm_role_assignment" "pre_BlobContributor_mi" {
  scope                            = data.azurerm_resource_group.rg.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "pre_reader_mi" {
  scope                            = data.azurerm_resource_group.rg.id
  role_definition_name             = "Reader"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "vm_user_mi" {
  scope                            = data.azurerm_resource_group.rg.id
  role_definition_name             = "Virtual Machine Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id
  skip_service_principal_aad_check = true
}

# Give PowerApp Appreg contributor access to resource groups
resource "azurerm_role_assignment" "powerapp_appreg" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = var.dts_pre_ent_appreg_oid
}

resource "azurerm_role_assignment" "ado" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "dcd_sp_ado" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = "11a86dfb-2183-4f42-ac53-9952bd31d0fb"
}

resource "azurerm_key_vault_access_policy" "power_app_access" {
  key_vault_id            = module.key-vault.key_vault_id
  object_id               = var.dts_pre_app_admin
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = ["List", "Update", "Create", "Import", "Delete", "Get", ]
  certificate_permissions = ["List", "Update", "Create", "Import", "Delete", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", ]
  secret_permissions      = ["List", "Set", "Delete", "Get", ]
}

# DTS-PRE-App-<env> Admin perms
# resource "azurerm_role_assignment" "pre_app_admin" {
#   for_each             = toset(data.azuread_groups.contributor_groups.object_ids)
#   scope                = data.azurerm_resource_group.rg.id
#   role_definition_name = "Storage Account Contributor"
#   principal_id         = each.value
# }

resource "azurerm_role_assignment" "pre_app_admin_contributor" {
  for_each             = toset(data.azuread_groups.contributor_groups.object_ids)
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "pre_app_admin_storage_contributor" {
  for_each             = toset(data.azuread_groups.contributor_groups.object_ids)
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "pre_app_admin_user_admin" {
  for_each             = toset(data.azuread_groups.contributor_groups.object_ids)
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "User Access Administrator"
  principal_id         = each.value
}

# DTS-PRE-VideoEditing-SecurityGroup-<env>
resource "azurerm_role_assignment" "vmuser_login" {
  for_each             = toset(data.azuread_groups.VideoEditing_groups.object_ids)
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = each.value
}