module "vm_automation_dtgtwy" {
  source = "git@github.com:hmcts/cnp-module-automation-runbook-start-stop-vm?ref=master"

  product                 = "${var.product}-dtgtwy"
  env                     = var.env
  location                = var.location
  automation_account_name = azurerm_automation_account.pre-aa.name
  tags                    = var.common_tags
  schedules = [
    {
      name      = "vm-on"
      frequency = "Day"
      interval  = 1
      run_time  = "06:00:00"
      start_vm  = false
    },
    {
      name      = "vm-off"
      frequency = "Day"
      interval  = 1
      run_time  = "18:00:00"
      start_vm  = false
    }
  ]
  resource_group_name = azurerm_resource_group.rg.name
  vm_names            = ["predtgtwy0-${var.env}", "predtgtwy1-${var.env}"]
  mi_principal_id     = azurerm_automation_account.pre-aa.identity[0].principal_id

}
