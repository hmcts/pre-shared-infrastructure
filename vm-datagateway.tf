# resource "azurerm_network_interface" "dtgwnic" {
#   count                         = var.num_datagateway
#   name                          = "${var.product}-dtgwnic${count.index}-${var.env}"
#   location                      = data.azurerm_resource_group.rg.location
#   resource_group_name           = data.azurerm_resource_group.rg.name
#   enable_accelerated_networking = true

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = data.azurerm_subnet.datagateway_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
#   tags = var.common_tags
# }

# resource "azurerm_windows_virtual_machine" "dtgtwyvm" {
#   count                      = var.num_datagateway
#   zone                       = 2
#   name                       = "${var.product}dtgtwy${count.index}-${var.env}"
#   computer_name              = "PREDTGTW0${count.index}-${var.env}"
#   resource_group_name        = data.azurerm_resource_group.rg.name
#   location                   = data.azurerm_resource_group.rg.location
#   size                       = var.datagateway_spec
#   admin_username             = data.azurerm_key_vault_secret.dtgtwy_username[count.index].value
#   admin_password             = data.azurerm_key_vault_secret.dtgtwy_password[count.index].value
#   network_interface_ids      = [azurerm_network_interface.dtgwnic[count.index].id]
#   encryption_at_host_enabled = true

#   os_disk {
#     name                   = "${var.product}dtgtwy${count.index}-osdisk-${var.env}"
#     caching                = "ReadWrite"
#     storage_account_type   = "Standard_LRS"
#     disk_encryption_set_id = data.azurerm_disk_encryption_set.pre-des.id
#   }
#   identity {
#     type         = "SystemAssigned, UserAssigned"
#     identity_ids = [data.azurerm_user_assigned_identity.managed_identity.id]
#   }
#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2019-datacenter-gensecond"
#     version   = "latest"
#   }
#   timezone                   = "GMT Standard Time"
#   enable_automatic_updates   = true
#   provision_vm_agent         = true
#   allow_extension_operations = true
#   tags                       = var.common_tags
# }

# resource "azurerm_managed_disk" "dtgtwaydatadisk" {
#   count                  = var.num_datagateway
#   name                   = "${var.product}dtgtwy${count.index}-datadisk-${var.env}"
#   location               = data.azurerm_resource_group.rg.location
#   resource_group_name    = data.azurerm_resource_group.rg.name
#   storage_account_type   = "Standard_LRS"
#   create_option          = "Empty"
#   disk_size_gb           = 1000
#   zone                   = "2"
#   disk_encryption_set_id = data.azurerm_disk_encryption_set.pre-des.id
#   tags                   = var.common_tags
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "dtgtwy" {
#   count              = var.num_datagateway
#   managed_disk_id    = azurerm_managed_disk.dtgtwaydatadisk.*.id[count.index]
#   virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
#   lun                = "3"
#   caching            = "ReadWrite"
# }

# module "dynatrace-oneagent-datagateway" {
#   count = var.num_datagateway

#   source               = "git@github.com:hmcts/terraform-module-vm-bootstrap.git?ref=master"
#   os_type              = "Windows"
#   virtual_machine_id   = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
#   virtual_machine_type = "vm"

#   # Dynatrace OneAgent
#   dynatrace_hostgroup = var.hostgroup
#   dynatrace_server    = var.server
#   dynatrace_tenant_id = data.azurerm_key_vault_secret.dynatrace-tenant-id.value
#   dynatrace_token     = try(data.azurerm_key_vault_secret.dynatrace-token.value, null)
# }

module "data_gateway_vm" {
  count                = var.num_datagateway
  source               = "git::https://github.com/hmcts/terraform-vm-module.git?ref=master"
  vm_type              = local.vm_type
  vm_name              = "pre-dg-vm${count.index + 1}-${var.env}"
  vm_resource_group    = data.azurerm_resource_group.rg.name
  vm_location          = var.location
  vm_size              = local.vm_size
  vm_admin_name        = data.azurerm_key_vault_secret.dtgtwy_username[count.index].value
  vm_admin_password    = data.azurerm_key_vault_secret.dtgtwy_password[count.index].value
  vm_availabilty_zones = local.vm_availabilty_zones[count.index]
  managed_disks        = var.vm_data_disks[count.index]

  #Disk Encryption
  kv_name     = "pre-${var.env}"
  kv_rg_name  = "pre-${var.env}"
  encrypt_ADE = true

  nic_name      = lower("data-gateway-vm${count.index + 1}-nic-${var.env}")
  ipconfig_name = local.ipconfig_name
  vm_subnet_id  = local.vm_subnet_id
  vm_private_ip = var.vm_private_ip[count.index]

  marketplace_sku       = local.marketplace_sku
  marketplace_publisher = local.marketplace_publisher
  marketplace_product   = local.marketplace_product

  #storage_image_reference
  vm_publisher_name = local.marketplace_publisher
  vm_offer          = local.marketplace_product
  vm_sku            = local.marketplace_sku
  vm_version        = local.vm_version

  boot_diagnostics_enabled = local.boot_diagnostics_enabled
  # boot_storage_uri         = local.boot_storage_uri

  # splunk_username     = try(data.azurerm_key_vault_secret.splunk_username[0].value, null)
  # splunk_password     = try(data.azurerm_key_vault_secret.splunk_password[0].value, null)
  # splunk_pass4symmkey = try(data.azurerm_key_vault_secret.splunk_pass4symmkey[0].value, null)

  nessus_install = false #var.nessus_install
  # nessus_server  = var.nessus_server
  # nessus_key     = try(data.azurerm_key_vault_secret.nessus_key[0].value, null)
  # nessus_groups  = var.nessus_groups

  dynatrace_hostgroup = var.hostgroup
  dynatrace_server    = var.server
  dynatrace_tenant_id = var.tenant_id
  dynatrace_token     = try(data.azurerm_key_vault_secret.dynatrace-token.value, null)

  #mount the disks
  additional_script_uri  = local.additional_script_uri
  additional_script_name = local.additional_script_name

  run_command    = true
  rc_script_file = "scripts/windows_cis.ps1"


  tags = var.common_tags

}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "dtgtwyvm" {
  count              = var.num_datagateway
  virtual_machine_id = module.data_gateway_vm.*.vm_id[count.index] #azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  location           = data.azurerm_resource_group.rg.location
  enabled            = false

  daily_recurrence_time = "1800"
  timezone              = "GMT Standard Time"


  notification_settings {
    enabled = false
  }
  tags = var.common_tags

  depends_on = [module.data_gateway_vm]
}

locals {
  vm_type = "windows"

  vm_size       = "Standard_F8s_v2"
  ipconfig_name = "IP_CONFIGURATION"

  vm_subnet_id = data.azurerm_subnet.datagateway_subnet.id

  vm_availabilty_zones  = [1, 2]
  marketplace_product   = "WindowsServer"
  marketplace_publisher = "MicrosoftWindowsServer"
  marketplace_sku       = "2019-Datacenter-gensecond"
  vm_version            = "latest"

  boot_diagnostics_enabled = false
  # boot_storage_uri         = data.azurerm_storage_account.db_boot_diagnostics_storage.primary_blob_endpoint

  dynatrace_env = var.tenant_id == "yrk32651" ? "nonprod" : var.tenant_id == "ebe20728" ? "prod" : null

  additional_script_uri  = "https://raw.githubusercontent.com/hmcts/CIS-harderning/master/windows-disk-mounting.ps1"
  additional_script_name = "windows-disk-mounting.ps1"
}