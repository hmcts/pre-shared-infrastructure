# locals {
#   vm_state_import = var.env == "stg" ? ["something"] : []
# }
#
# import {
#   for_each = local.vm_state_import
#   to       = module.edit_vm[0].module.vm-bootstrap[0].azurerm_virtual_machine_extension.dynatrace_oneagent[0]
#   id       = "/subscriptions/74dacd4f-a248-45bb-a2f0-af700dc4cf68/resourceGroups/pre-stg/providers/Microsoft.Compute/virtualMachines/edit-vm1-stg/extensions/Dynatrace"
# }
