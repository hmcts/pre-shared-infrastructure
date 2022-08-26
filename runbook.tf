resource "azurerm_automation_account" "vm-start-stop" {
  name                = "${var.product}-${var.env}-aa"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Basic"

 identity {
    type         = "UserAssigned"
    identity_ids = module.key-vault.managed_identity_id
  }

  tags = var.common_tags
}

module "vm_automation" {
  source = "git::https://github.com/hmcts/cnp-module-automation-runbook-start-stop-vm"

  product                 = "pre"
  env                     = var.env
  location                = var.location
  automation_account_name = azurerm_automation_account.vm-start-stop.name
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
  vm_names = [azurerm_windows_virtual_machine.vm.*.name,azurerm_windows_virtual_machine.dtgtwyvm.*.name ]
#     for wowza_vm in azurerm_linux_virtual_machine.wowza : wowza_vm.name
#   ]
  mi_principal_id         = module.key-vault.managed_identity_objectid
}


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