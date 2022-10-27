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


# ###################################################
# #            Editting VM NETWORK INTERFACE CARD               #
# ###################################################
# resource "azurerm_network_interface" "edtvmnic" {
#   count               = var.num_vid_edit_vms
#   name                = "${var.product}-edtvmnic${count.index}-${var.env}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   # enable_accelerated_networking  = true
#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.videoeditvm_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
#    tags                = var.common_tags
# }
# resource "azurerm_managed_disk" "edtvmdatadisk" {
#   count                = var.num_vid_edit_vms
#   name                 = "${var.product}-videdit${count.index}-datadisk-${var.env}"
#   location             = azurerm_resource_group.rg.location
#   resource_group_name  = azurerm_resource_group.rg.name
#   storage_account_type = "StandardSSD_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = 1000
#   # zone                 = "2"
#   disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
#   tags                 = var.common_tags
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "edtvm" {
#   count              = var.num_vid_edit_vms
#   managed_disk_id    = azurerm_managed_disk.edtvmdatadisk.*.id[count.index]
#   virtual_machine_id = azurerm_windows_virtual_machine.edtvm.*.id[count.index]
#   lun                = "3"
#   caching            = "ReadWrite"
# }

# ###################################################
# #                EDIT VIRTUAL MACHINE                 #
# ###################################################
# resource "azurerm_windows_virtual_machine" "edtvm" {
#   count                 = var.num_vid_edit_vms
#   # zone                = 2
#   name                  = "${var.product}edtvm${count.index}-${var.env}"
#   computer_name         = "PREEDTVM0${count.index}-${var.env}"
#   resource_group_name   = azurerm_resource_group.rg.name
#   location              = azurerm_resource_group.rg.location
#   size                  = var.vid_edit_vm_spec
#   admin_username        = "videdit${count.index}_${random_string.vm_username[count.index].result}"
#   admin_password        = random_password.vm_password[count.index].result
#   network_interface_ids = [azurerm_network_interface.edtvmnic[count.index].id]

#   os_disk {
#     name                 = "${var.product}-edtvm${count.index}-osdisk-${var.env}"
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#     disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
#   }
#   identity {
#     type = "SystemAssigned"
#   }
  
#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2019-datacenter-gensecond"
#     version   = "latest"
#   }
#   enable_automatic_updates = true
#   provision_vm_agent       = true  
#   timezone                 = "GMT Standard Time"
#   tags                     = var.common_tags

#   depends_on = [ module.key-vault]
# }

##################################################
##           Editing NETWORK INTERFACE CARD               #
###################################################
resource "azurerm_network_interface" "nics" {
  count               = var.num_vid_edit_vms
  name                = "${var.product}-videditvmnic${count.index}-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.videoeditvm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
   tags                = var.common_tags
}

###################################################
#                 Editing VIRTUAL MACHINE                 #
###################################################
resource "azurerm_windows_virtual_machine" "vm" {
  count                       = var.num_vid_edit_vms
  name                        = "${var.product}-videditvm${count.index}-${var.env}"
  computer_name               = "PREVIDED0${count.index}-${var.env}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  size                        = var.vid_edit_vm_spec
  admin_username              = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  admin_password              = random_password.vm_password[count.index].result
  network_interface_ids       = [azurerm_network_interface.nics[count.index].id]
  encryption_at_host_enabled  = true

  # additional_capabilities {
  #  ultra_ssd_enabled   =  true
  # }
  
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

  timezone                 = "GMT Standard Time"
  enable_automatic_updates = true
  provision_vm_agent       = true  
  tags                     = var.common_tags

  depends_on = [ module.key-vault, azurerm_disk_encryption_set.pre-des ]
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
# resource "azurerm_security_center_server_vulnerability_assessment" "vulass" {
#   count                  = var.num_vid_edit_vms
#   virtual_machine_id = azurerm_windows_virtual_machine.vm.*.id[count.index]
# }



# resource "azurerm_dev_test_global_vm_shutdown_schedule" "editvm" {
#   count                  = var.num_vid_edit_vms
#   virtual_machine_id     = azurerm_windows_virtual_machine.vm.*.id[count.index]
#   location               = azurerm_resource_group.rg.location
#   enabled                = true

#   daily_recurrence_time = "1800"
#   timezone              = "GMT Standard Time"


#   notification_settings {
#     enabled         = false
   
#   }
#   tags                = var.common_tags
#  }

##DynaTrace

module "dynatrace-oneagent" {
  
  source               = "git@github.com:hmcts/terraform-module-dynatrace-oneagent.git?ref=master"
  count                = var.num_vid_edit_vms
  tenant_id            = data.azurerm_key_vault_secret.dynatrace-tenant-id.value
  token                =  data.azurerm_key_vault_secret.dynatrace-token.value
  virtual_machine_os   = "windows"
  virtual_machine_type = "vm"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.*.id[count.index]
  auto_upgrade_minor_version = true
  server                     = var.server
  hostgroup                  = var.hostgroup

}

resource "azurerm_virtual_machine_extension" "msmonitor-agent" {
  depends_on                 = [  azurerm_virtual_machine_extension.daa-agent  ]
  name                       = "MicrosoftMonitoringAgent"  # Must be called this
  count                      = var.num_vid_edit_vms
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       =  "1.0"
  tags                       = var.common_tags
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


# ###################################################
# #            Datagateway NETWORK INTERFACE CARD               #
# ###################################################
# resource "azurerm_network_interface" "dtgwnic" {
#   count               = var.num_datagateway
#   name                = "${var.product}-dtgwnic${count.index}-${var.env}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

# resource "azurerm_security_center_server_vulnerability_assessment_virtual_machine" "va" {
#   virtual_machine_id = azurerm_windows_virtual_machine.vm.*.id
# }
# resource "azurerm_managed_disk" "datadisk" {
#   count                = var.num_datagateway
#   name                 = "${var.product}-dtgtwy${count.index}-datadisk-${var.env}"
#   location             = azurerm_resource_group.rg.location
#   resource_group_name  = azurerm_resource_group.rg.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = 100
#   zone                 = "2"
#   disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
#   tags                 = var.common_tags
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "dtgtwy" {
#   count              = var.num_datagateway
#   managed_disk_id    = azurerm_managed_disk.datadisk.*.id[count.index]
#   virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
#   lun                = "3"
#   caching            = "ReadWrite"
# }

resource "azurerm_virtual_machine_extension" "dtgtwydaa-agent" {
  name                       = "DependencyAgentWindows"
  count                      = var.num_datagateway
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
  count                      = var.num_datagateway
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
  count                 = var.num_datagateway
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
  lifecycle {
    ignore_changes= [name ]
  }
}

module "dynatrace-oneagent-dtgtway" {
  
  source                     = "github.com/hmcts/terraform-module-dynatrace-oneagent"
  count                      = var.num_datagateway
  tenant_id                  = data.azurerm_key_vault_secret.dynatrace-tenant-id.value
  token                      = data.azurerm_key_vault_secret.dynatrace-token.value
  virtual_machine_os         = "Windows"
  virtual_machine_type       = "vm"
  virtual_machine_id         = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  auto_upgrade_minor_version = true
  server                     = var.server
  hostgroup                  = var.hostgroup
  
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "dtgtwyvm" {
  count                  = var.num_datagateway
  virtual_machine_id     = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  location               = azurerm_resource_group.rg.location
  enabled                = true

#   os_disk {
#     name                 = "${var.product}-dtgtwy${count.index}-osdisk-${var.env}"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#     disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
#   }
#   identity {
#     type = "SystemAssigned"
#   }
  
#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2019-datacenter-gensecond"
#     version   = "latest"
#   }
#   enable_automatic_updates = true
#   provision_vm_agent       = true  
#   tags                     = var.common_tags

#   depends_on = [ module.key-vault]
# }

<<<<<<<<< Temporary merge branch 1
=========
# resource "azurerm_managed_disk" "datadisk" {
#   count                = var.num_datagateway
#   name                 = "${var.product}-dtgtwy${count.index}-datadisk-${var.env}"
#   location             = azurerm_resource_group.rg.location
#   resource_group_name  = azurerm_resource_group.rg.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = 100
#   zone                 = 2
#   tags                 = var.common_tags
# }

>>>>>>>>> Temporary merge branch 2

# resource "azurerm_virtual_machine_extension" "disk-encryption" {
#   name                 = "DiskEncryption"
#   location             = "${local.location}"
#   resource_group_name  = "${azurerm_resource_group.environment-rg.name}"
#   virtual_machine_name = "${azurerm_virtual_machine.server.name}"
#   publisher            = "Microsoft.Azure.Security"
#   type                 = "AzureDiskEncryption"
#   type_handler_version = "2.2"

#   settings = <<SETTINGS
# {
#   "EncryptionOperation": "EnableEncryption",
#   "KeyVaultURL": "https://${local.vaultname}.vault.azure.net",
#   "KeyVaultResourceId": "/subscriptions/${local.subscriptionid}/resourceGroups/${local.vaultresourcegroup}/providers/Microsoft.KeyVault/vaults/${local.vaultname}",
#   "KeyEncryptionKeyURL": "https://${local.vaultname}.vault.azure.net/keys/${local.keyname}/${local.keyversion}",
#   "KekVaultResourceId": "/subscriptions/${local.subscriptionid}/resourceGroups/${local.vaultresourcegroup}/providers/Microsoft.KeyVault/vaults/${local.vaultname}",
#   "KeyEncryptionAlgorithm": "RSA-OAEP",
#   "VolumeType": "All"
# }
# SETTINGS
# }