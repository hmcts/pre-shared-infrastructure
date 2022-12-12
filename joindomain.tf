resource "azurerm_virtual_machine_extension" "vm_aad" {
  count                      =  var.num_vid_edit_vms
  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  tags                       = var.common_tags

#   depends_on = [
#     azurerm_virtual_machine_extension.joinactivedirectory[0]
#   ]
}

# resource "azurerm_virtual_machine_extension" "joinactivedirectory" {
#   count = var.join_domain == true ? var.num_vid_edit_vms : 0

#   depends_on = [
#     azurerm_windows_virtual_machine.vm
#   ]

#   name                 = "${var.product}-joinad"
#   virtual_machine_id   = azurerm_windows_virtual_machine.vm.*.id[count.index]
#   publisher            = "Microsoft.Compute"
#   type                 = "JsonADDomainExtension"
#   type_handler_version = "1.3"
#   settings             = <<SETTINGS
#     {
#         "Name": "HMCTS.NET",
#         "OUPath": "OU=Test-OU,DC=hmcts,DC=net",
#         "User": "${var.domain_username}",
#         "Restart": "true",
#         "Options": "3"
#     }
#   SETTINGS
#   protected_settings   = <<PROTECTED_SETTINGS
#     {
#       "Password": "${var.domain_password}"
#     }
#   PROTECTED_SETTINGS
# }

# TODO aad group ID 
# resource "azurerm_role_assignment" "rbac_user_login" {
#   for_each             = toset(data.azuread_groups.groups.object_ids)
#   principal_id         = each.value
#   scope                = azurerm_windows_virtual_machine.vm.*.id
#   role_definition_name = "Virtual Machine User Login"
# }


# #DTS Pre-recorded Evidence
# resource "azurerm_role_assignment" "rbac_admin_login" {
#   for_each             = toset(data.azuread_groups.pre-groups.object_ids)
#   principal_id         = each.value
#   scope                = azurerm_windows_virtual_machine.vm.id
#   role_definition_name = "Virtual Machine Administrator Login"
# }


