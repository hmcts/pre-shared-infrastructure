data "azurerm_client_config" "current" {}

resource "time_offset" "tomorrow" {
  offset_days = 1
}

locals {
  update_time = var.update_time
  update_date = substr(time_offset.tomorrow.rfc3339, 0, 10)
  datetime    = replace("${local.update_date}T${local.update_time}", "/:/", "-")
}

#This type should eventually replace the manual deploy via azurerm: azurerm_automation_softwareUpdateConfigurations
#https://github.com/terraform-providers/terraform-provider-azurerm/issues/2812
#https://docs.microsoft.com/en-us/rest/api/automation/softwareupdateconfigurations/create

resource "azurerm_resource_group_template_deployment" "linux" {
  count               = lower(var.operatingSystem) == "linux" ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name

  template_content = <<DEPLOY
    {
        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        "contentVersion": "1.0.0.0",
        "resources": [
            {
                "apiVersion": "2017-05-15-preview",
                "type": "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations",
                "name": "${var.azurerm_automation_account.name}/${var.name}",
                "properties": {
                    "updateConfiguration": {
                        "operatingSystem": "${var.operatingSystem}",
                        "duration": "PT${var.duration}H",
                        "linux": {
                            "excludedPackageNameMasks": [],
                            "includedPackageClassifications": "${var.linux_update_types}",
                            "rebootSetting": "${var.rebootSetting}"
                        },
                        "azureVirtualMachines": [],
                        "nonAzureComputerNames": [],
                        "targets": {
                            "azureQueries": [
                                {
                                    "scope": ${jsonencode(var.scope)}
                                }
                            ],
                            "nonAzureQueries": []
                        }
                    },
                    "scheduleInfo": {
                        "frequency": "${var.frequency}",
                        "startTime": "${local.update_date}T${local.update_time}:00-00:00",
                        "timeZone": "${var.timeZone}",
                        "interval": ${var.interval},
                        "advancedSchedule": {
                            "weekDays": ${jsonencode(var.weekDays)},
                            "monthDays": ${jsonencode(var.monthDays)}
                        }
                    }
                }
            }
        ]
    }
    DEPLOY

  deployment_mode = "Incremental"
}

resource "null_resource" "linux" {
  count = lower(var.operatingSystem) == "linux" ? 1 : 0
  triggers = {
    subscription    = data.azurerm_client_config.current.subscription_id
    resource_group  = var.resource_group_name
    deployment_name = var.name
  }
  provisioner "local-exec" {
    when    = destroy
    command = "az deployment group delete --subscription ${self.triggers.subscription} --resource-group ${self.triggers.resource_group} --name ${self.triggers.deployment_name}"
  }
}

resource "azurerm_resource_group_template_deployment" "windows" {
  count               = lower(var.operatingSystem) == "windows" ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name

  template_content = <<DEPLOY
    {
        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        "contentVersion": "1.0.0.0",
        "resources": [
            {
                "apiVersion": "2017-05-15-preview",
                "type": "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations",
                "name": "${var.azurerm_automation_account.name}/${var.name}",
                "properties": {
                    "updateConfiguration": {
                        "operatingSystem": "${var.operatingSystem}",
                        "duration": "PT${var.duration}H",
                        "windows": {
                            "excludedKbNumbers": [],
                            "includedUpdateClassifications": "${var.windows_update_types}",
                            "rebootSetting": "${var.rebootSetting}"
                        },
                        "azureVirtualMachines": [],
                        "nonAzureComputerNames": [],
                        "targets": {
                            "azureQueries": [
                                {
                                    "scope": ${jsonencode(var.scope)}
                                }
                            ],
                            "nonAzureQueries": []
                        }
                    },
                    "scheduleInfo": {
                        "frequency": "${var.frequency}",
                        "startTime": "${local.update_date}T${local.update_time}:00-00:00",
                        "timeZone": "${var.timeZone}",
                        "interval": ${var.interval},
                        "advancedSchedule": {
                            "weekDays": ${jsonencode(var.weekDays)},
                            "monthDays": ${jsonencode(var.monthDays)}
                        }
                    }
                }
            }
        ]
    }
    DEPLOY

  deployment_mode = "Incremental"
}

resource "null_resource" "windows" {
  count = lower(var.operatingSystem) == "windows" ? 1 : 0
  triggers = {
    subscription    = data.azurerm_client_config.current.subscription_id
    resource_group  = var.resource_group_name
    deployment_name = var.name
  }
  provisioner "local-exec" {
    when    = destroy
    command = "az deployment group delete --subscription ${self.triggers.subscription} --resource-group ${self.triggers.resource_group} --name ${self.triggers.deployment_name}"
  }
}