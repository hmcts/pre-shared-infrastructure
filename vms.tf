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
  name                   = "${var.product}-bastion-${var.env}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  copy_paste_enabled     = true
  file_copy_enabled      = true
  sku                    = "Standard"
  ip_connect_enabled     = true
  scale_units            = 2
  shareable_link_enabled = true
  tunneling_enabled      = true

  ip_configuration {
    name                 = "bastionpublic"
    subnet_id            = azurerm_subnet.AzureBastionSubnet_subnet.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  tags = var.common_tags

}

###
## Encryption@Host
#######

resource "null_resource" "Encryption" {

  provisioner "local-exec" {
    command = <<EOF
    az login --identity
    az account set -s dts-sharedservices-${var.env}
    echo "Enable Encryption at Host"
    az feature register --namespace Microsoft.Compute --name EncryptionAtHost
	  EOF
  }
}

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
  tags = var.common_tags
}
resource "azurerm_windows_virtual_machine" "vm" {
  zone                       = 2
  count                      = var.num_vid_edit_vms
  name                       = "${var.product}-videditvm${count.index}-${var.env}"
  computer_name              = "PREVIDED0${count.index}-${var.env}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  size                       = var.vid_edit_vm_spec
  admin_username             = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  admin_password             = random_password.vm_password[count.index].result
  network_interface_ids      = [azurerm_network_interface.nic[count.index].id]
  encryption_at_host_enabled = true


  # encryption_at_host_enabled  = true

  additional_capabilities {
    ultra_ssd_enabled = true
  }


  os_disk {
    name                   = "${var.product}-videditvm${count.index}-osdisk-${var.env}"
    caching                = "ReadWrite"
    storage_account_type   = "StandardSSD_LRS" #UltraSSD_LRS?
    disk_encryption_set_id = azurerm_disk_encryption_set.pre-des.id
    disk_size_gb           = 1000
  }


  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h1-pro-g2"
    version   = "latest"
  }
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = module.key-vault.managed_identity_id
  }

  timezone                   = "GMT Standard Time"
  enable_automatic_updates   = true
  provision_vm_agent         = true
  allow_extension_operations = true
  tags                       = var.common_tags

  depends_on = [null_resource.Encryption, module.key-vault, azurerm_disk_encryption_set.pre-des]
}

# # Datadisk 
resource "azurerm_virtual_machine_data_disk_attachment" "vmdatadisk" {
  count              = var.num_vid_edit_vms
  managed_disk_id    = azurerm_managed_disk.vmdatadisk.*.id[count.index]
  virtual_machine_id = azurerm_windows_virtual_machine.vm.*.id[count.index]
  lun                = "3"
  caching            = "ReadWrite"
}

## Managed Disk
resource "azurerm_managed_disk" "vmdatadisk" {
  count                  = var.num_vid_edit_vms
  name                   = "${var.product}-videditvm${count.index}-datadisk-${var.env}"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  storage_account_type   = "StandardSSD_LRS"
  create_option          = "Empty"
  disk_size_gb           = 1000
  disk_encryption_set_id = azurerm_disk_encryption_set.pre-des.id
  zone                   = "2"
  tags                   = var.common_tags


}


# # This extension is needed for other extensions
resource "azurerm_virtual_machine_extension" "daa-agent" {
  name                       = "DependencyAgentWindows"
  count                      = var.num_vid_edit_vms
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  tags                       = var.common_tags
}


## Add logging and monitoring extensions
resource "azurerm_virtual_machine_extension" "monitor-agent" {
  depends_on                 = [azurerm_virtual_machine_extension.daa-agent]
  name                       = "AzureMonitorWindowsAgent"
  count                      = var.num_vid_edit_vms
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.5"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  tags                       = var.common_tags
}


resource "azurerm_virtual_machine_extension" "msmonitor-agent" {
  depends_on           = [azurerm_virtual_machine_extension.daa-agent]
  name                 = "MicrosoftMonitoringAgent" # Must be called this
  count                = var.num_vid_edit_vms
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"
  tags                 = var.common_tags
  settings             = <<SETTINGS
    {
        "workspaceId": "${data.azurerm_log_analytics_workspace.loganalytics.workspace_id}",
        "azureResourceId": "${azurerm_windows_virtual_machine.vm.*.id[count.index]}",
        "stopOnMultipleConnections": "false"
    }
  SETTINGS
  protected_settings   = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${data.azurerm_log_analytics_workspace.loganalytics.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "vmextension" {
  name                       = "IaaSAntimalware"
  count                      = var.num_vid_edit_vms
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
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
  tags                       = var.common_tags
}

##DynaTrace

module "dynatrace-oneagent" {

  source                     = "git@github.com:hmcts/terraform-module-dynatrace-oneagent.git?ref=master"
  count                      = var.num_vid_edit_vms
  tenant_id                  = data.azurerm_key_vault_secret.dynatrace-tenant-id.value
  token                      = data.azurerm_key_vault_secret.dynatrace-token.value
  virtual_machine_os         = "windows"
  virtual_machine_type       = "vm"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  auto_upgrade_minor_version = true
  server                     = var.server
  hostgroup                  = var.hostgroup
  tags                       = var.common_tags
}


####
## DataGateway VMs
####
###################################################
#            Datagateway NETWORK INTERFACE CARD               #
###################################################
resource "azurerm_network_interface" "dtgwnic" {
  count                         = var.num_datagateway
  name                          = "${var.product}-dtgwnic${count.index}-${var.env}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.datagateway_subnet.id
    private_ip_address_allocation = "Dynamic"
    network_security_group_id     = azurerm_network_security_group.dtgwnsg.id
  }
  tags = var.common_tags
}

###################################################
#            Datagateway NSG               #
###################################################
resource "azurerm_network_security_group" "dtgwnsg" {
  name                = "${var.product}-dtgwsg${count.index}-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.common_tags
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.dtgwnsg.name
}

resource "azurerm_network_security_rule" "block_internet_outbound" {
  name                        = "block-internet-outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.dtgwnsg.name
}

###################################################
#                DATAGATEWAY VIRTUAL MACHINE                 #
###################################################
resource "azurerm_windows_virtual_machine" "dtgtwyvm" {
  count                      = var.num_datagateway
  zone                       = 2
  name                       = "${var.product}dtgtwy${count.index}-${var.env}"
  computer_name              = "PREDTGTW0${count.index}-${var.env}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  size                       = var.datagateway_spec
  admin_username             = "Dtgtwy${count.index}_${random_string.dtgtwy_username[count.index].result}"
  admin_password             = random_password.dtgtwy_password[count.index].result
  network_interface_ids      = [azurerm_network_interface.dtgwnic[count.index].id]
  encryption_at_host_enabled = true

  os_disk {
    name                   = "${var.product}dtgtwy${count.index}-osdisk-${var.env}"
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_encryption_set_id = azurerm_disk_encryption_set.pre-des.id
  }
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = module.key-vault.managed_identity_id
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  timezone                   = "GMT Standard Time"
  enable_automatic_updates   = true
  provision_vm_agent         = true
  allow_extension_operations = true
  tags                       = var.common_tags
  depends_on                 = [module.key-vault]
}

resource "azurerm_managed_disk" "dtgtwaydatadisk" {
  count                  = var.num_datagateway
  name                   = "${var.product}dtgtwy${count.index}-datadisk-${var.env}"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  storage_account_type   = "Standard_LRS"
  create_option          = "Empty"
  disk_size_gb           = 1000
  zone                   = "2"
  disk_encryption_set_id = azurerm_disk_encryption_set.pre-des.id
  tags                   = var.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "dtgtwy" {
  count              = var.num_datagateway
  managed_disk_id    = azurerm_managed_disk.dtgtwaydatadisk.*.id[count.index]
  virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  lun                = "3"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_extension" "dtgtwayvmextension" {
  name                      = "IaaSAntimalware"
  count                      = var.num_datagateway
  virtual_machine_id         = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
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
  tags                       = var.common_tags
}

resource "azurerm_virtual_machine_extension" "dtgtwydaa-agent" {
  name                       = "DependencyAgentWindows"
  count                      = var.num_datagateway
  virtual_machine_id         = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  tags                       = var.common_tags
}


# Add logging and monitoring extensions
resource "azurerm_virtual_machine_extension" "dtgtwymonitor-agent" {
  depends_on                 = [azurerm_virtual_machine_extension.dtgtwydaa-agent]
  name                       = "AzureMonitorWindowsAgent"
  count                      = var.num_datagateway
  virtual_machine_id         = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.5"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  tags                       = var.common_tags
}

module "dynatrace-oneagent-dtgtway" {

  source                     = "git@github.com:hmcts/terraform-module-dynatrace-oneagent.git?ref=master"
  count                      = var.num_datagateway
  tenant_id                  = data.azurerm_key_vault_secret.dynatrace-tenant-id.value
  token                      = data.azurerm_key_vault_secret.dynatrace-token.value
  virtual_machine_os         = "Windows"
  virtual_machine_type       = "vm"
  virtual_machine_id         = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  auto_upgrade_minor_version = true
  server                     = var.server
  hostgroup                  = var.hostgroup
  tags                       = var.common_tags

}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "dtgtwyvm" {
  count              = var.num_datagateway
  virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  location           = azurerm_resource_group.rg.location
  enabled            = false

  daily_recurrence_time = "1800"
  timezone              = "GMT Standard Time"


  notification_settings {
    enabled = false
  }
  tags = var.common_tags
}
