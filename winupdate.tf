# //== Provider used to store timestamp for updates ==//
# provider "time" {
#   version = "~> 0.4"
# }

//== Store 1 day in the future, only update if [local.update_time] is altered ==//
resource "time_offset" "next_day" {
  offset_days = 1
  triggers = {
    update_time = local.update_time
  }
}

locals {
  update_time = "19:40"
  update_date = substr(time_offset.next_day.rfc3339, 0, 10)
  update_timezone = "UTC"
  update_max_hours = "4"
  update_classifications = "Critical, Security, UpdateRollup, ServicePack, Definition, Updates"
  update_reboot_settings = "IfRequired"
  update_day = "Saturday"
  update_occurrence = "2"
}

#This type should eventually replace the manual deploy via azurerm: azurerm_automation_softwareUpdateConfigurations
#https://github.com/terraform-providers/terraform-provider-azurerm/issues/2812
resource "azurerm_template_deployment" "windows" {
  count               =  var.num_vid_edit_vms
  name                = "windows-update"
  resource_group_name = azurerm_resource_group.rg.name

  template_body = <<DEPLOY
  {
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
      {
          "apiVersion": "2017-05-15-preview",
          "type": "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations",
          "name": "${azurerm_automation_account.pre-aa.name}/windows-updates",
          "properties": {
              "updateConfiguration": {
                  "operatingSystem": "Windows",
                  "duration": "PT${local.update_max_hours}H",
                  "windows": {
                      "excludedKbNumbers": [
                      ],
                      "includedUpdateClassifications": "${local.update_classifications}",
                      "rebootSetting": "${local.update_reboot_settings}"
                  },
                  "azureVirtualMachines": [
                      "${azurerm_windows_virtual_machine.vm.*.id[count.index]}"
                      
                  ],
                  "nonAzureComputerNames": [
                  ]
              },
              "scheduleInfo": {
                  "frequency": "Month",
                  "startTime": "${local.update_date}T${local.update_time}:00",
                  "timeZone":  "${local.update_timezone}",
                  "interval": 1,
                  "advancedSchedule": {
                      "monthlyOccurrences": [
                          {
                            "occurrence": "${local.update_occurrence}",
                            "day": "${local.update_day}"
                          }
                      ]
                  }
              }
          }
      }
    ]
  }
  DEPLOY

  deployment_mode = "Incremental"
}


resource "azurerm_resource_group_template_deployment" "dtgtwwindows" {
  count               =  var.num_datagateway
  name                = "windows-update"
  resource_group_name = azurerm_resource_group.rg.name

  template_body = <<DEPLOY
  {
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
      {
          "apiVersion": "2017-05-15-preview",
          "type": "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations",
          "name": "${azurerm_automation_account.pre-aa.name}/windows-updates",
          "properties": {
              "updateConfiguration": {
                  "operatingSystem": "Windows",
                  "duration": "PT${local.update_max_hours}H",
                  "windows": {
                      "excludedKbNumbers": [
                      ],
                      "includedUpdateClassifications": "${local.update_classifications}",
                      "rebootSetting": "${local.update_reboot_settings}"
                  },
                  "azureVirtualMachines": [
                      "${azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]}"
                      ],
                  "nonAzureComputerNames": [
                  ]
              },
              "scheduleInfo": {
                  "frequency": "Month",
                  "startTime": "${local.update_date}T${local.update_time}:00",
                  "timeZone":  "${local.update_timezone}",
                  "interval": 1,
                  "advancedSchedule": {
                      "monthlyOccurrences": [
                          {
                            "occurrence": "${local.update_occurrence}",
                            "day": "${local.update_day}"
                          }
                      ]
                  }
              }
          }
      }
    ]
  }
  DEPLOY

  deployment_mode = "Incremental"
}