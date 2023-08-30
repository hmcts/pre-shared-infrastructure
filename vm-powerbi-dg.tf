module "powerBI_data_gateway" {
  count                          = var.num_datagateway
  source                         = "git@github.com:hmcts/terraform-module-virtual-machine.git?ref=DTSPO-14774-Before-change"
  vm_type                        = local.powerbi_dg_vm_type
  vm_name                        = "powerbi-${count.index + 1}-${var.env}"
  computer_name                  = "powerbi${count.index + 1}${var.env}"
  vm_resource_group              = data.azurerm_resource_group.rg.name
  vm_location                    = var.location
  vm_size                        = local.powerbi_dg_vm_size
  vm_admin_name                  = azurerm_key_vault_secret.powerbi_dg_username[count.index].value
  vm_admin_password              = azurerm_key_vault_secret.powerbi_dg_password[count.index].value
  vm_availabilty_zones           = local.powerbi_dg_vm_availability_zones[count.index]
  managed_disks                  = var.powerbi_dg_vm_data_disks[count.index]
  accelerated_networking_enabled = true
  privateip_allocation           = "Static"
  # custom_data                    = filebase64("./scripts/datagateway-init.ps1")

  #Disk Encryption
  kv_name     = var.env == "prod" ? "${var.product}-hmctskv-${var.env}" : "${var.product}-${var.env}"
  kv_rg_name  = "pre-${var.env}"
  encrypt_ADE = true

  nic_name      = lower("powerbi-dg${count.index + 1}-nic-${var.env}")
  ipconfig_name = local.powerbi_dg_ipconfig_name
  vm_subnet_id  = local.powerbi_dg_vm_subnet_id
  vm_private_ip = var.powerbi_dg_vm_private_ip[count.index]

  #storage_image_reference
  vm_publisher_name = local.powerbi_dg_marketplace_publisher
  vm_offer          = local.powerbi_dg_marketplace_product
  vm_sku            = local.powerbi_dg_marketplace_sku
  vm_version        = local.powerbi_dg_vm_version

  boot_diagnostics_enabled = local.powerbi_dg_boot_diagnostics_enabled

  nessus_install = false #var.nessus_install

  dynatrace_hostgroup = var.hostgroup
  dynatrace_server    = var.server
  dynatrace_tenant_id = var.tenant_id
  dynatrace_token     = try(data.azurerm_key_vault_secret.dynatrace-token.value, null)

  #mount the disks
  additional_script_uri  = local.powerbi_dg_additional_script_uri
  additional_script_name = local.powerbi_dg_additional_script_name

  run_command    = true
  rc_script_file = "scripts/windows_cis.ps1"


  tags = var.common_tags

}

locals {
  powerbi_dg_vm_type = "windows"

  powerbi_dg_vm_size       = "Standard_D8ds_v5"
  powerbi_dg_ipconfig_name = "IP_CONFIGURATION"

  powerbi_dg_vm_subnet_id = data.azurerm_subnet.datagateway_subnet.id

  powerbi_dg_vm_availability_zones = [1, 2]
  powerbi_dg_marketplace_product   = "WindowsServer"
  powerbi_dg_marketplace_publisher = "MicrosoftWindowsServer"
  powerbi_dg_marketplace_sku       = "2019-Datacenter-gensecond"
  powerbi_dg_vm_version            = "latest"

  powerbi_dg_boot_diagnostics_enabled = false
  # boot_storage_uri         = data.azurerm_storage_account.db_boot_diagnostics_storage.primary_blob_endpoint

  powerbi_dg_dynatrace_env = var.tenant_id == "yrk32651" ? "nonprod" : var.tenant_id == "ebe20728" ? "prod" : null

  powerbi_dg_additional_script_uri  = "https://raw.githubusercontent.com/hmcts/CIS-harderning/master/windows-disk-mounting.ps1"
  powerbi_dg_additional_script_name = "windows-disk-mounting.ps1"
  # dg_init_script               = format("%s%s%s", "[ ", "\"https://raw.githubusercontent.com/hmcts/pre-shared-infrastructure/preview/scripts/datagateway-init.ps1\"", " ]")
}


# Datagateway
resource "random_string" "powerbi_dg_username" {
  count   = var.num_datagateway
  length  = 4
  special = false
}

resource "random_password" "powerbi_dg_password" {
  count            = var.num_datagateway
  length           = 16
  special          = true
  override_special = "$%&@()-_=+[]{}<>:?"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "powerbi_dg_username" {
  count        = var.num_datagateway
  name         = "powerbi-dg${count.index + 1}-username"
  value        = "powerbi_dg${count.index + 1}_${random_string.powerbi_dg_username[count.index].result}"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "powerbi_dg_password" {
  count        = var.num_datagateway
  name         = "powerbi-dg${count.index + 1}-password"
  value        = random_password.powerbi_dg_password[count.index].result
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "powerbi_dg_recovery" {
  count        = var.num_datagateway
  name         = "powerbi-dg${count.index + 1}-recovery-key"
  value        = random_password.powerbi_dg_password[count.index].result
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
