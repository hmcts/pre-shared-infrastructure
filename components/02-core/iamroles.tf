#Storage Blob Data Contributor Role Assignment for Managed Identity
resource "azurerm_role_assignment" "pre_BlobContributor_mi" {
  scope                            = data.azurerm_resource_group.rg.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id #var.pre_mi_principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "pre_reader_mi" {
  scope                            = data.azurerm_resource_group.rg.id
  role_definition_name             = "Reader"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id # var.pre_mi_principal_id 
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "vm_user_mi" {
  scope                            = data.azurerm_resource_group.rg.id
  role_definition_name             = "Virtual Machine Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id # var.pre_mi_principal_id 
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

resource "azurerm_role_assignment" "ado" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = "11a86dfb-2183-4f42-ac53-9952bd31d0fb" #dcd_sp_ado_dev_operations_v2
}

# resource "azurerm_key_vault_access_policy" "power_app_access" {
#   key_vault_id            = module.key-vault.key_vault_id
#   object_id               = var.power_app_user_oid
#   tenant_id               = data.azurerm_client_config.current.tenant_id
#   key_permissions         = ["List", "Update", "Create", "Import", "Delete", "Get", ]
#   certificate_permissions = ["List", "Update", "Create", "Import", "Delete", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", ]
#   secret_permissions      = ["List", "Set", "Delete", "Get", ]
# }

# #role should be assigned already
# # DTS-PRE-VideoEditing-SecurityGroup-
# data "azuread_groups" "groups" {
#   display_names = ["DTS-PRE-VideoEditing-SecurityGroup-${var.env}"]
# }

# data "azuread_groups" "pre-groups" {
#   display_names = ["DTS Pre-recorded Evidence"]
# }
# resource "azurerm_role_assignment" "vmuser_login" {
#   for_each             = toset(data.azuread_groups.groups.object_ids)
#   scope                = azurerm_resource_group.rg.id
#   role_definition_name = "Virtual Machine User Login"
#   principal_id         = each.value
# }