resource "azurerm_network_interface" "dtgwnic" {
  count                         = var.num_datagateway
  name                          = "${var.product}-dtgwnic${count.index}-${var.env}"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.datagateway_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.common_tags
}

resource "azurerm_windows_virtual_machine" "dtgtwyvm" {
  count                      = var.num_datagateway
  zone                       = 2
  name                       = "${var.product}dtgtwy${count.index}-${var.env}"
  computer_name              = "PREDTGTW0${count.index}-${var.env}"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location
  size                       = var.datagateway_spec
  admin_username             = data.azurerm_key_vault_secret.dtgtwy_username[count.index].value
  admin_password             = data.azurerm_key_vault_secret.dtgtwy_password[count.index].value
  network_interface_ids      = [azurerm_network_interface.dtgwnic[count.index].id]
  encryption_at_host_enabled = true

  os_disk {
    name                   = "${var.product}dtgtwy${count.index}-osdisk-${var.env}"
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_encryption_set_id = data.azurerm_disk_encryption_set.pre-des.id
  }
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.managed_identity.id]
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
}

resource "azurerm_managed_disk" "dtgtwaydatadisk" {
  count                  = var.num_datagateway
  name                   = "${var.product}dtgtwy${count.index}-datadisk-${var.env}"
  location               = data.azurerm_resource_group.rg.location
  resource_group_name    = data.azurerm_resource_group.rg.name
  storage_account_type   = "Standard_LRS"
  create_option          = "Empty"
  disk_size_gb           = 1000
  zone                   = "2"
  disk_encryption_set_id = data.azurerm_disk_encryption_set.pre-des.id
  tags                   = var.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "dtgtwy" {
  count              = var.num_datagateway
  managed_disk_id    = azurerm_managed_disk.dtgtwaydatadisk.*.id[count.index]
  virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  lun                = "3"
  caching            = "ReadWrite"
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


# # Add logging and monitoring extensions
# resource "azurerm_virtual_machine_extension" "dtgtwymonitor-agent" {
#   depends_on                 = [azurerm_virtual_machine_extension.dtgtwydaa-agent]
#   name                       = "AzureMonitorWindowsAgent"
#   count                      = var.num_datagateway
#   virtual_machine_id         = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
#   publisher                  = "Microsoft.Azure.Monitor"
#   type                       = "AzureMonitorWindowsAgent"
#   type_handler_version       = "1.5"
#   automatic_upgrade_enabled  = true
#   auto_upgrade_minor_version = true
#   tags                       = var.common_tags
# }

module "dynatrace-oneagent-datagateway" {
  count = var.num_datagateway

  source               = "git@github.com:hmcts/terraform-module-vm-bootstrap.git?ref=master"
  os_type              = "Windows"
  virtual_machine_id   = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  virtual_machine_type = "vm"

  # Dynatrace OneAgent
  dynatrace_hostgroup = var.hostgroup
  dynatrace_server    = var.server
  dynatrace_tenant_id = data.azurerm_key_vault_secret.dynatrace-tenant-id.value
  dynatrace_token     = try(data.azurerm_key_vault_secret.dynatrace-token.value, null)
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "dtgtwyvm" {
  count              = var.num_datagateway
  virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  location           = data.azurerm_resource_group.rg.location
  enabled            = false

  daily_recurrence_time = "1800"
  timezone              = "GMT Standard Time"


  notification_settings {
    enabled = false
  }
  tags = var.common_tags
}
