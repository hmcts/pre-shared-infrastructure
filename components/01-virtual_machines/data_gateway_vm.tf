resource "azurerm_network_interface" "dtgwnic" {
  count                         = var.num_datagateway
  name                          = "${var.prefix}-dtgwnic${count.index}-${var.env}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.datagateway_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = module.tags.common_tags
}

resource "azurerm_windows_virtual_machine" "dtgtwyvm" {
  count                      = var.num_datagateway
  zone                       = 2
  name                       = "${var.prefix}dtgtwy${count.index}-${var.env}"
  computer_name              = "PREDTGTW0${count.index}-${var.env}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  size                       = var.datagateway_spec
  admin_username             = "Dtgtwy${count.index}_${random_string.dtgtwy_username[count.index].result}"
  admin_password             = random_password.dtgtwy_password[count.index].result
  network_interface_ids      = [azurerm_network_interface.dtgwnic[count.index].id]
  encryption_at_host_enabled = true

  os_disk {
    name                   = "${var.prefix}dtgtwy${count.index}-osdisk-${var.env}"
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
  tags                       = module.tags.common_tags
  depends_on                 = [module.key-vault]
}

resource "azurerm_managed_disk" "dtgtwaydatadisk" {
  count                  = var.num_datagateway
  name                   = "${var.prefix}dtgtwy${count.index}-datadisk-${var.env}"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  storage_account_type   = "Standard_LRS"
  create_option          = "Empty"
  disk_size_gb           = 1000
  zone                   = "2"
  disk_encryption_set_id = azurerm_disk_encryption_set.pre-des.id
  tags                   = module.tags.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "dtgtwy" {
  count              = var.num_datagateway
  managed_disk_id    = azurerm_managed_disk.dtgtwaydatadisk.*.id[count.index]
  virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  lun                = "3"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_extension" "dtgtwayvmextension" {
  name                       = "IaaSAntimalware"
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
  tags                       = module.tags.common_tags
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
  tags                       = module.tags.common_tags
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
  tags                       = module.tags.common_tags
}

module "dynatrace-oneagent-dtgtway" {

  source                     = "git::https://github.com/hmcts/terraform-module-dynatrace-oneagent.git?ref=master"
  count                      = var.num_datagateway
  tenant_id                  = data.azurerm_key_vault_secret.dynatrace-tenant-id.value
  token                      = data.azurerm_key_vault_secret.dynatrace-token.value
  virtual_machine_os         = "Windows"
  virtual_machine_type       = "vm"
  virtual_machine_id         = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  auto_upgrade_minor_version = true
  server                     = var.server
  hostgroup                  = var.hostgroup
  tags                       = module.tags.common_tags

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
  tags = module.tags.common_tags
}
