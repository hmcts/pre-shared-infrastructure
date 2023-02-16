data "azurerm_user_assigned_identity" "managed-identity" {
  name                = "${var.prefix}-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"

  depends_on = [module.key-vault]
}

# resource "azurerm_user_assigned_identity" "managed-identity" {
#   name                = "${var.prefix}-${var.env}-mi"
#   resource_group_name = "managed-identities-${var.env}-rg"
# }

# data "azuread_groups" "groups" {
#   display_names = ["DTS-PRE-VideoEditing-SecurityGroup-${var.env}"]
# }

# data "azuread_groups" "pre-groups" {
#   display_names = ["DTS Pre-recorded Evidence"]
# }

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

# role should be assigned already
# # DTS-PRE-VideoEditing-SecurityGroup-
# resource "azurerm_role_assignment" "vmuser_login" {
#   for_each             = toset(data.azuread_groups.groups.object_ids)
#   scope                = azurerm_resource_group.rg.id
#   role_definition_name = "Virtual Machine User Login"
#   principal_id         = each.value
# }