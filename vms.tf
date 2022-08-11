##------------------------------------------------------###################
##BASTION
##------------------------------------------------------###################
resource "azurerm_public_ip" "pip" {
  name                = "${var.product}-bastionpip-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

##------------------------------------------------------###################
##BASTION
##------------------------------------------------------###################
resource "azurerm_bastion_host" "bastion" {
  name                = "${var.product}-bastion-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "bastionpublic"
    subnet_id                     = azurerm_subnet.AzureBastionSubnet_subnet.id
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
  tags = var.common_tags

}

# locals {
#   tenantId             = data.azurerm_client_config.current.tenant_id
#   clientId             = data.azurerm_client_config.current.CLIENT_id
#   secret               = data.azurerm_client_config.current.CLIENT_SECRET
#   }

# # data.azurerm_client_config.current.tenant_id
# # $subscriptionId = $env:ARM_SUBSCRIPTION_ID
# # $tenantId = $env:ARM_TENANT_ID
# # $clientId = $env:ARM_CLIENT_ID
# # $secret = $env:ARM_CLIENT_SECRET

# # az.cmd login --service-principal --username locals.clientId --password locals.secret --tenant locals.tenantId

# resource "null_resource" "azcli_exec" {
#   provisioner "local-exec" {
#     command = "az.cmd login --service-principal --username ${local.clientId} --password ${local.secret} --tenant ${local.tenantId} && az set -s ${var.subscription} && az feature register --namespace Microsoft.Compute --name EncryptionAtHost"
    
#     # "az feature registration create --name EncryptionAtHost --namespace Microsoft.Compute"
# # "Register-AzProviderFeature -FeatureName \"EncryptionAtHost\" -ProviderNamespace \"Microsoft.Compute\" "
#   }
# }
# ###################################################
# #                EDIT VIRTUAL MACHINE                 #
# ###################################################

resource "azurerm_network_interface" "nic" {
  count               = var.num_vid_edit_vms
  name                = "${var.product}-videditnic${count.index}-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.videoeditvm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
   tags                = var.common_tags
}
resource "azurerm_windows_virtual_machine" "vm" {
  count                       = var.num_vid_edit_vms
  name                        = "${var.product}-videditvm${count.index}-${var.env}"
  computer_name               = "PREVIDED0${count.index}-${var.env}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  size                        = var.vid_edit_vm_spec
  admin_username              = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  admin_password              = random_password.vm_password[count.index].result
  network_interface_ids       = [azurerm_network_interface.nic[count.index].id]
  
#    # (Optional) To enable Azure Monitoring and install log analytics agents
#   # (Optional) Specify `storage_account_name` to save monitoring logs to storage.   
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

#   # Deploy log analytics agents to virtual machine. 
#   # Log analytics workspace customer id and primary shared key required.
#   deploy_log_analytics_agent                 = true
#   log_analytics_customer_id                  = azurerm_log_analytics_workspace.law.workspace_id
#   log_analytics_workspace_primary_shared_key = azurerm_log_analytics_workspace.law.primary_shared_key

#   # encryption_at_host_enabled  = true

#   # additional_capabilities {
#   #  ultra_ssd_enabled   =  true
#   # }
  

#   # Add logging and monitoring


# # This extension is needed for other extensions

  os_disk {
    name                      = "${var.product}-videditvm${count.index}-osdisk-${var.env}"
    caching                   = "ReadWrite"
    storage_account_type      = "StandardSSD_LRS" #UltraSSD_LRS?
    disk_encryption_set_id    = azurerm_disk_encryption_set.pre-des.id
    # write_accelerator_enabled = true
  }

  
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h1-pro-g2"
    version   = "latest"
  }
  # identity {
  #   type = "SystemAssigned"
  #   }

  timezone                     = "GMT Standard Time"
  enable_automatic_updates     = true
  provision_vm_agent           = true  
  allow_extension_operations   = true
  patch_mode                   = "AutomaticByOS"
  tags                         = var.common_tags

  depends_on = [ module.key-vault, azurerm_disk_encryption_set.pre-des ]
}

resource "azurerm_virtual_machine_extension" "daa-agent" {
  name                       = "DependencyAgentWindows"
  count                      = var.num_vid_edit_vms
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  tags                    = var.common_tags
}


# Add logging and monitoring extensions
resource "azurerm_virtual_machine_extension" "monitor-agent" {
  depends_on = [  azurerm_virtual_machine_extension.daa-agent  ]
  name                  = "AzureMonitorWindowsAgent"
  count                      = var.num_vid_edit_vms
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher             = "Microsoft.Azure.Monitor"
  type                  = "AzureMonitorWindowsAgent"
  type_handler_version  =  "1.5"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  tags                    = var.common_tags
}


resource "azurerm_virtual_machine_extension" "msmonitor-agent" {
  depends_on = [  azurerm_virtual_machine_extension.daa-agent  ]
  name                  = "MicrosoftMonitoringAgent"  # Must be called this
  count                      = var.num_vid_edit_vms
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher             = "Microsoft.EnterpriseCloud.Monitoring"
  type                  = "MicrosoftMonitoringAgent"
  type_handler_version  =  "1.0"
  tags                    = var.common_tags
  # Not yet supported
  # automatic_upgrade_enabled  = true
  # auto_upgrade_minor_version = true
  settings = <<SETTINGS
    {
        "workspaceId": "${data.azurerm_log_analytics_workspace.loganalytics.workspace_id}",
        "azureResourceId": "${azurerm_windows_virtual_machine.vm.*.id[count.index]}",
        "stopOnMultipleConnections": "false"
    }
  SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${data.azurerm_log_analytics_workspace.loganalytics.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}

resource "azurerm_managed_disk" "vmdatadisk" {
  count                   = var.num_vid_edit_vms
  name                    = "${var.product}-videditvm${count.index}-datadisk-${var.env}"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  storage_account_type    = "StandardSSD_LRS"
  create_option           = "Empty"
  disk_size_gb            = 1000
  disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
  tags                    = var.common_tags

     
}

resource "azurerm_virtual_machine_data_disk_attachment" "vmdatadisk" {
  count              = var.num_vid_edit_vms
  managed_disk_id    = azurerm_managed_disk.vmdatadisk.*.id[count.index]
  virtual_machine_id = azurerm_windows_virtual_machine.vm.*.id[count.index]
  lun                = "3"
  caching            = "ReadWrite"
}

# resource "azurerm_security_center_server_vulnerability_assessment_virtual_machine" "va" {
#   virtual_machine_id = azurerm_windows_virtual_machine.vm.*.id
# }

resource "azurerm_virtual_machine_extension" "vmextension" {
  name                 = "IaaSAntimalware"
  count                = var.num_vid_edit_vms
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.3"
  auto_upgrade_minor_version = true
  settings = <<SETTINGS
    {
    "AntimalwareEnabled": true,
    "RealtimeProtectionEnabled": "true",
    "ScheduledScanSettings": {
    "isEnabled": "true",
    "day": "1",
    "time": "120",
    "scanType": "Quick"
    },
    "Exclusions": {
    "Extensions": "",
    "Paths": "",
    "Processes": ""
    }
    }
SETTINGS
  tags                = var.common_tags
}
# resource "azurerm_security_center_server_vulnerability_assessment" "vulass" {
#   count                  = var.num_vid_edit_vms
#   virtual_machine_id = azurerm_windows_virtual_machine.vm.*.id[count.index]
# }



resource "azurerm_dev_test_global_vm_shutdown_schedule" "editvm" {
  count                  = var.num_vid_edit_vms
  virtual_machine_id     = azurerm_windows_virtual_machine.vm.*.id[count.index]
  location               = azurerm_resource_group.rg.location
  enabled                = true

  daily_recurrence_time = "1800"
  timezone              = "GMT Standard Time"


  notification_settings {
    enabled         = false
   
  }
  tags                = var.common_tags
 }


###################################################
#            Datagateway NETWORK INTERFACE CARD               #
###################################################
resource "azurerm_network_interface" "dtgwnic" {
  count               = var.num_datagateway
  name                = "${var.product}-dtgwnic${count.index}-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.datagateway_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
   tags                = var.common_tags
}

###################################################
#                DATAGATEWAY VIRTUAL MACHINE                 #
###################################################
resource "azurerm_windows_virtual_machine" "dtgtwyvm" {
  count               = var.num_datagateway
  zone                = 2
  name                = "${var.product}dtgtwy${count.index}-${var.env}"
  computer_name       = "PREDTGTW0${count.index}-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.datagateway_spec
  admin_username      = "Dtgtwy${count.index}_${random_string.dtgtwy_username[count.index].result}"
  admin_password      = random_password.dtgtwy_password[count.index].result
  network_interface_ids = [azurerm_network_interface.dtgwnic[count.index].id]

  os_disk {
    name                 = "${var.product}dtgtwy${count.index}-osdisk-${var.env}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
  }
  # identity {
  #   type = "SystemAssigned"
  # }module

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  enable_automatic_updates = true
  provision_vm_agent       = true  
  tags                     = var.common_tags

  depends_on = [ module.key-vault]
}

resource "azurerm_managed_disk" "dtgtwaydatadisk" {
  count                = var.num_datagateway
  name                 = "${var.product}dtgtwy${count.index}-datadisk-${var.env}"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
  zone                 = "2"
  disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
  tags                 = var.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "dtgtwy" {
  count              = var.num_datagateway
  managed_disk_id    = azurerm_managed_disk.dtgtwaydatadisk.*.id[count.index]
  virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  lun                = "3"
  caching            = "ReadWrite"
}

# resource "azurerm_virtual_machine_extension" "dtgtwayvmextension" {
#   name                 = "IaaSAntimalware"
#   count                = var.num_datagateway
#   virtual_machine_id   = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
#   publisher            = "Microsoft.Azure.Security"
#   type                 = "IaaSAntimalware"
#   type_handler_version = "1.3"
#   auto_upgrade_minor_version = true
#   settings = <<SETTINGS
#     {
#     "AntimalwareEnabled": true,
#     "RealtimeProtectionEnabled": "true",
#     "ScheduledScanSettings": {
#     "isEnabled": "true",
#     "day": "1",
#     "time": "120",
#     "scanType": "Quick"
#     },
#     "Exclusions": {
#     "Extensions": "",
#     "Paths": "",
#     "Processes": ""
#     }
#     }
# SETTINGS
#   tags                = var.common_tags
# }
# resource "azurerm_security_center_server_vulnerability_assessment" "vulneass" {
#   count                  = var.num_datagateway
#   virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
# }

resource "azurerm_virtual_machine_extension" "dtgtwydaa-agent" {
  name                       = "DependencyAgentWindows"
  count                      = var.num_vid_edit_vms
  virtual_machine_id         = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  tags                    = var.common_tags
}


# Add logging and monitoring extensions
resource "azurerm_virtual_machine_extension" "dtgtwymonitor-agent" {
  depends_on = [  azurerm_virtual_machine_extension.dtgtwydaa-agent  ]
  name                  = "AzureMonitorWindowsAgent"
  count                      = var.num_vid_edit_vms
  virtual_machine_id         = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  publisher             = "Microsoft.Azure.Monitor"
  type                  = "AzureMonitorWindowsAgent"
  type_handler_version  =  "1.5"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  tags                    = var.common_tags
}


resource "azurerm_virtual_machine_extension" "dtgtwymsmonitor-agent" {
  depends_on = [  azurerm_virtual_machine_extension.dtgtwydaa-agent  ]
  name                  = "MicrosoftMonitoringAgent"  # Must be called this
  count                 = var.num_vid_edit_vms
  virtual_machine_id    = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  publisher             = "Microsoft.EnterpriseCloud.Monitoring"
  type                  = "MicrosoftMonitoringAgent"
  type_handler_version  =  "1.0"
  tags                    = var.common_tags
  # Not yet supported
  # automatic_upgrade_enabled  = true
  # auto_upgrade_minor_version = true
  settings = <<SETTINGS
    {
        "workspaceId": "${data.azurerm_log_analytics_workspace.loganalytics.workspace_id}",
        "azureResourceId": "${azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]}",
        "stopOnMultipleConnections": "false"
    }
  SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${data.azurerm_log_analytics_workspace.loganalytics.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "dtgtwyvm" {
  count                  = var.num_vid_edit_vms
  virtual_machine_id     = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  location               = azurerm_resource_group.rg.location
  enabled                = true

  daily_recurrence_time = "1800"
  timezone              = "GMT Standard Time"


  notification_settings {
    enabled         = false
   
  }
  tags                = var.common_tags
 }
