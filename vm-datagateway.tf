module "data_gateway_vm" {
  count                          = var.num_datagateway
  source                         = "git@github.com:hmcts/terraform-vm-module.git?ref=master"
  vm_type                        = local.dg_vm_type
  vm_name                        = "dg-vm${count.index + 1}-${var.env}"
  vm_resource_group              = data.azurerm_resource_group.rg.name
  vm_location                    = var.location
  vm_size                        = local.dg_vm_size
  vm_admin_name                  = azurerm_key_vault_secret.dg_username[count.index].value
  vm_admin_password              = azurerm_key_vault_secret.dg_password[count.index].value
  vm_availabilty_zones           = local.dg_vm_availabilty_zones[count.index]
  managed_disks                  = var.dg_vm_data_disks[count.index]
  accelerated_networking_enabled = true

  #Disk Encryption
  kv_name     = "pre-${var.env}"
  kv_rg_name  = "pre-${var.env}"
  encrypt_ADE = true

  nic_name      = lower("dg-vm${count.index + 1}-nic-${var.env}")
  ipconfig_name = local.dg_ipconfig_name
  vm_subnet_id  = local.dg_vm_subnet_id
  vm_private_ip = var.dg_vm_private_ip[count.index]

  marketplace_sku       = local.dg_marketplace_sku
  marketplace_publisher = local.dg_marketplace_publisher
  marketplace_product   = local.dg_marketplace_product

  #storage_image_reference
  vm_publisher_name = local.dg_marketplace_publisher
  vm_offer          = local.dg_marketplace_product
  vm_sku            = local.dg_marketplace_sku
  vm_version        = local.dg_vm_version

  boot_diagnostics_enabled = local.dg_boot_diagnostics_enabled

  nessus_install = false #var.nessus_install

  dynatrace_hostgroup = var.hostgroup
  dynatrace_server    = var.server
  dynatrace_tenant_id = var.tenant_id
  dynatrace_token     = try(data.azurerm_key_vault_secret.dynatrace-token.value, null)

  #mount the disks
  additional_script_uri  = local.dg_additional_script_uri
  additional_script_name = local.dg_additional_script_name

  run_command    = true
  rc_script_file = "scripts/windows_cis.ps1"


  tags = var.common_tags

}

resource "azurerm_virtual_machine_extension" "dg_init" {
  count                = var.num_datagateway
  name                 = "dgCustomScript"
  virtual_machine_id   = module.data_gateway_vm.*.vm_id[count.index]
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScriptExtension"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File datagateway-init.ps1"

 }
SETTINGS


  tags = var.common_tags
}


resource "azurerm_dev_test_global_vm_shutdown_schedule" "dg_vm" {
  count              = var.num_datagateway
  virtual_machine_id = module.data_gateway_vm.*.vm_id[count.index]
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
  dg_vm_type = "windows"

  dg_vm_size       = "Standard_F8s_v2"
  dg_ipconfig_name = "IP_CONFIGURATION"

  dg_vm_subnet_id = data.azurerm_subnet.datagateway_subnet.id

  dg_vm_availabilty_zones  = [1, 2]
  dg_marketplace_product   = "WindowsServer"
  dg_marketplace_publisher = "MicrosoftWindowsServer"
  dg_marketplace_sku       = "2019-Datacenter-gensecond"
  dg_vm_version            = "latest"

  dg_boot_diagnostics_enabled = false
  # boot_storage_uri         = data.azurerm_storage_account.db_boot_diagnostics_storage.primary_blob_endpoint

  dg_dynatrace_env = var.tenant_id == "yrk32651" ? "nonprod" : var.tenant_id == "ebe20728" ? "prod" : null

  dg_additional_script_uri  = "https://raw.githubusercontent.com/hmcts/CIS-harderning/master/windows-disk-mounting.ps1"
  dg_additional_script_name = "windows-disk-mounting.ps1"
}


# Datagateway
resource "random_string" "dg_username" {
  count   = var.num_datagateway
  length  = 4
  special = false
}

resource "random_password" "dg_password" {
  count            = var.num_datagateway
  length           = 16
  special          = true
  override_special = "$%&@()-_=+[]{}<>:?"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "dg_username" {
  count        = var.num_datagateway
  name         = "dg${count.index + 1}-username"
  value        = "dg${count.index + 1}_${random_string.dg_username[count.index].result}"
  key_vault_id = data.azurerm_key_vault.pre_kv.id
}

resource "azurerm_key_vault_secret" "dg_password" {
  count        = var.num_datagateway
  name         = "dg${count.index + 1}-password"
  value        = random_password.dg_password[count.index].result
  key_vault_id = data.azurerm_key_vault.pre_kv.id
}