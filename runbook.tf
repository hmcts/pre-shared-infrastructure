resource "azurerm_automation_account" "pre-aa" {
  name                = "${var.product}-${var.env}-aa"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Basic"

 identity {
    type         = "UserAssigned"
    identity_ids = module.key-vault.managed_identity_id
    }
  # lifecycle {
  #   ignore_changes= [ name]
  # }

  tags = var.common_tags
}

module "vm_automation" {
  # editvmcount = var.num_vid_edit_vms
  # dtgtwycount = var.num_datagateway
  source = "git::https://github.com/hmcts/cnp-module-automation-runbook-start-stop-vm"

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
  # "module.key-vault.managed_identity_id" 
}

resource "azurerm_log_analytics_linked_service" "la_linked_service" {
  provider            = azurerm.oms
  resource_group_name = data.azurerm_log_analytics_workspace.loganalytics.resource_group_name
  workspace_id        = module.log_analytics_workspace.workspace_id
  read_access_id      = azurerm_automation_account.pre-aa.id
}


resource "azurerm_log_analytics_solution" "update_solution" {
  provider              = azurerm.oms
  solution_name         = "Updates"
  location              = var.location
  resource_group_name   = data.azurerm_log_analytics_workspace.loganalytics.resource_group_name #module.log_analytics_workspace.resource_group_name
  workspace_resource_id = module.log_analytics_workspace.workspace_id
  workspace_name        = module.log_analytics_workspace.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
  depends_on = [
    azurerm_log_analytics_linked_service.la_linked_service
  ]

}

# data "azurerm_automation_account" "pre-aa" {
#   name                = "${var.product}-${var.env}-aa"
#   resource_group_name = azurerm_resource_group.rg.name
# }

#  for vms in azurerm_windows_virtual_machine.vm : vms.name

# resource "azurerm_automation_account" "automateacct" {
#   name                = "${var.product}${var.env}-autoacc"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   sku {
#     name = "Basic"
#   }
# }

# resource "azurerm_automation_schedule" "scheduledstartvm" {
#   name                    = "StartVM"
#   resource_group_name     = azurerm_resource_group.rg.name
#   automation_account_name = "roonbookautomation"
#   frequency               = "Day"
#   interval                = 1
#   timezone                = "America/Chicago"
#   start_time              = "2021-09-20T13:00:00Z"
#   description             = "Run every day"
# }

# resource "azurerm_automation_job_schedule" "startvm_sched" {
#   resource_group_name     = azurerm_resource_group.rg.name
#   automation_account_name = "runbookautomation"
#   schedule_name           = azurerm_automation_schedule.scheduledstartvm.name
#   runbook_name            = azurerm_automation_runbook.startstopvmrunbook.name
#    parameters = {
#     action        = "Start"
#   }
#   depends_on = [azurerm_automation_schedule.scheduledstartvm]
# }

# resource "azurerm_automation_schedule" "scheduledstopvm" {
#   name                    = "StopVM"
#   resource_group_name     = azurerm_resource_group.rg.name
#   automation_account_name = "testautomation"
#   frequency               = "Day"
#   interval                = 1
#   timezone                = "America/Chicago"
#   start_time              = "2021-09-20T10:30:00Z"
#   description             = "Run every day"
# }

# resource "azurerm_automation_job_schedule" "stopvm_sched" {
#   resource_group_name     = azurerm_resource_group.rg.name
#   automation_account_name = "testautomation"
#   schedule_name           = azurerm_automation_schedule.scheduledstopvm.name
#   runbook_name            = azurerm_automation_runbook.startstopvmrunbook.name
#   parameters = {
#     action        = "Stop"
#   }
#   depends_on = [azurerm_automation_schedule.scheduledstopvm]
# }