resource "azurerm_network_interface" "nic" {
  count               = var.num_vid_edit_vms
  name                = "${var.prefix}-videditnic${count.index}-${var.env}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.videoedit_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = module.tags.common_tags
}
resource "azurerm_windows_virtual_machine" "vm" {
  zone                       = 2
  count                      = var.num_vid_edit_vms
  name                       = "${var.prefix}-videditvm${count.index}-${var.env}"
  computer_name              = "PREVIDED0${count.index}-${var.env}"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = var.location
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
    name                   = "${var.prefix}-videditvm${count.index}-osdisk-${var.env}"
    caching                = "ReadWrite"
    storage_account_type   = "StandardSSD_LRS" #UltraSSD_LRS?
    disk_encryption_set_id = azurerm_disk_encryption_set.pre-des.id
    disk_size_gb           = 1000
    # write_accelerator_enabled = true
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
  tags                       = module.tags.common_tags
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
  name                   = "${var.prefix}-videditvm${count.index}-datadisk-${var.env}"
  location               = var.location
  resource_group_name    = data.azurerm_resource_group.rg.name
  storage_account_type   = "StandardSSD_LRS"
  create_option          = "Empty"
  disk_size_gb           = 1000
  disk_encryption_set_id = azurerm_disk_encryption_set.pre-des.id
  zone                   = "2"
  tags                   = module.tags.common_tags


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
  tags                       = module.tags.common_tags
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
  tags                       = module.tags.common_tags
}

resource "azurerm_virtual_machine_extension" "vmextension" {
  name                       = "IaaSAntimalware"
  count                      = var.num_vid_edit_vms
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  tags                       = module.tags.common_tags
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
}

resource "azurerm_virtual_machine_extension" "vm_aad" {
  count                      = var.num_vid_edit_vms
  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  tags                       = module.tags.common_tags

}

#logs
resource "azurerm_monitor_diagnostic_setting" "nic" {
  count                      = var.num_vid_edit_vms
  name                       = azurerm_network_interface.nic[count.index].name
  target_resource_id         = azurerm_network_interface.nic[count.index].id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}