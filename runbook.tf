resource "azurerm_automation_account" "pre-aa" {
  name                = "${var.product}-${var.env}-aa"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Basic"

 identity {
    type         = "SystemAssigned"

    # UserAssigned"
    # identity_ids = data.azurerm_user_assigned_identity.managed-identity.principal_id
    }
  # lifecycle {
  #   ignore_changes= [ name]
  # }

  tags = var.common_tags
}

module "vm_automation" {

source =  "git@github.com:hmcts/cnp-module-automation-runbook-start-stop-vm?ref=master"
  product                 = var.product
  env                     = var.env
  location                = var.location
  automation_account_name = azurerm_automation_account.pre-aa.name
  tags                    = var.common_tags
  schedules               =  [
                      {
                        name        = "vm-on"
                        frequency   = "Day"
                        interval    = 1
                        run_time    = "06:00:00"
                        start_vm    = true
                      },
                      {
                        name        = "vm-off"
                        frequency   = "Day"
                        interval    = 1
                        run_time    = "18:00:00"
                        start_vm    = false
                      }
                     ]
  resource_group_name     = azurerm_resource_group.rg.name
  vm_names                = azurerm_windows_virtual_machine.vm.*.name
  mi_principal_id         = azurerm_automation_account.pre-aa.identity[0].principal_id 
}


module "vm_automation_dtgtwy" {
  source = "git@github.com:hmcts/cnp-module-automation-runbook-start-stop-vm?ref=master"

  product                 = "${var.product}-dtgtwy"
  env                     = var.env
  location                = var.location
  automation_account_name = azurerm_automation_account.pre-aa.name
  tags                    = var.common_tags
  schedules               =  [
                      {
                        name        = "vm-on"
                        frequency   = "Day"
                        interval    = 1
                        run_time    = "06:00:00"
                        start_vm    = true
                      },
                      {
                        name        = "vm-off"
                        frequency   = "Day"
                        interval    = 1
                        run_time    = "18:00:00"
                        start_vm    = false
                      }
                     ]
  resource_group_name     = azurerm_resource_group.rg.name
  vm_names                = azurerm_windows_virtual_machine.dtgtwyvm.*.name
  mi_principal_id         = azurerm_automation_account.pre-aa.identity[0].principal_id 
 
}


# data "azurerm_log_analytics_linked_service" "la_linked_service" {
#   provider            = azurerm.oms
#   resource_group_name = data.azurerm_log_analytics_workspace.loganalytics.resource_group_name
#   workspace_id        = module.log_analytics_workspace.workspace_id
# }


# resource "azurerm_log_analytics_solution" "update_solution" {
#   provider              = azurerm.oms
#   solution_name         = "Updates"
#   location              = var.location
#   resource_group_name   = data.azurerm_log_analytics_workspace.loganalytics.resource_group_name #module.log_analytics_workspace.resource_group_name
#   workspace_resource_id = module.log_analytics_workspace.workspace_id
#   workspace_name        = module.log_analytics_workspace.name
#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/Updates"
#   }

#   # depends_on = [
#   #   azurerm_log_analytics_linked_service.la_linked_service
#   # ]

# # }

# data "azurerm_automation_account" "pre-aa" {
#   name                = "${var.product}-${var.env}-aa"
#   resource_group_name = azurerm_resource_group.rg.name
# }

#  for vms in azurerm_windows_virtual_machine.vm : vms.name


#   depends_on = [
#     azurerm_log_analytics_linked_service.la_linked_service
#   ]

# }
