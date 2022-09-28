
 data "azurerm_user_assigned_identity" "managed-identity" {
  name                = "${var.product}-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}


#Storage Blob Data Contributor Role Assignment for Managed Identity
resource "azurerm_role_assignment" "pre_BlobContributor_mi" {
  scope                            = azurerm_resource_group.rg.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id #var.pre_mi_principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "pre_reader_mi" {
  scope                            = azurerm_resource_group.rg.id
  role_definition_name             = "Reader"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id # var.pre_mi_principal_id 
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "vm_user_mi" {
  scope                            = azurerm_resource_group.rg.id
  role_definition_name             = "Virtual Machine User Login"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id # var.pre_mi_principal_id 
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "vm_user" {
  scope                            = azurerm_resource_group.rg.id
  role_definition_name             = "Virtual Machine User Login"
  principal_id                     = azurerm_automation_account.pre-aa.identity[0].principal_id 
  skip_service_principal_aad_check = true
}

# resource "azurerm_role_assignment" "pre_power_app_blob" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Storage Blob Data Contributor"
#   principal_id                     = var.power_app_user_oid  
#   skip_service_principal_aad_check = true
# }

# resource "azurerm_role_assignment" "pre_power_app_user" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "User Administrator"
#   principal_id                     = var.power_app_user_oid 
#   skip_service_principal_aad_check = true
# }

# resource "azurerm_role_assignment" "pre_power_app_user_access" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "User Access Administrator"
#   principal_id                     = var.power_app_user_oid 
#   skip_service_principal_aad_check = true
# }


