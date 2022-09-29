
 data "azurerm_user_assigned_identity" "managed-identity" {
  name                = "${var.product}-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}

data "azuread_groups" "groups" {
  display_names = ["DTS-PRE-VideoEditing-SecurityGroup-${var.env}"]
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
  role_definition_name             = "Virtual Machine Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id # var.pre_mi_principal_id 
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "vm_user_aa" {
  scope                            = azurerm_resource_group.rg.id
  role_definition_name             = "Virtual Machine Contributor"
  principal_id                     = azurerm_automation_account.pre-aa.identity[0].principal_id 
  skip_service_principal_aad_check = true
}

# DTS-PRE-VideoEditing-SecurityGroup-
resource "azurerm_role_assignment" "vmuser_login" {
  for_each             = toset(data.azuread_groups.groups.object_ids)
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = each.value
}

# resource "azurerm_role_assignment" "vmnic_reader" {
#   count                = var.num_vid_edit_vms
#   scope                = azurerm_network_interface.nic[count.index].id
#   role_definition_name = "Reader"
#   principal_id         = data.azuread_groups.groups.id
# }

# resource "azurerm_role_assignment" "vm_reader" {
#   count                = var.num_vid_edit_vms
#   # for_each             = toset(data.azuread_groups.groups.object_ids)
#   scope                = azurerm_windows_virtual_machine.vm.*.id[count.index]
#   role_definition_name = "Reader"
#   principal_id         = data.azuread_groups.groups.id
# }

# resource "azurerm_role_assignment" "bastion_reader" {
#   for_each             = toset(data.azuread_groups.groups.object_ids)
#   scope                = azurerm_bastion_host.bastion.id
#   role_definition_name = "Reader"
#   principal_id         = each.value
# }

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


