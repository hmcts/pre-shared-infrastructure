data "azurerm_key_vault" "cnp_vault" {
  count = var.install_dynatrace_oa ? 1 : 0
  # provider            = azurerm.cnp
  name                = "pre-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault_secret" "token" {
  count = var.install_dynatrace_oa ? 1 : 0
  # provider = azurerm.cnp

  name         = "dynatrace-token"
  key_vault_id = data.azurerm_key_vault.cnp_vault[0].id
}

module "data_gateway_vm" {
  count                = local.vm_count
  source               = "git::https://github.com/hmcts/terraform-vm-module.git?ref=master"
  vm_type              = local.vm_type
  vm_name              = "dg-vm${count.index + 1}-${var.env}"
  vm_resource_group    = data.azurerm_resource_group.rg.name
  vm_location          = var.location
  vm_size              = local.vm_size
  vm_admin_name        = "dg-admin${count.index}_${random_string.dtgtwy_username[count.index].result}"
  vm_admin_password    = random_password.vm_password[count.index].result
  vm_availabilty_zones = local.vm_availabilty_zones[count.index]
  managed_disks        = var.vm_data_disks[count.index]

  #Disk Encryption
  kv_name     = "pre-dev"
  kv_rg_name  = "pre-dev"
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
  dynatrace_token     = try(data.azurerm_key_vault_secret.token[0].value, null)

  #mount the disks
  additional_script_uri  = local.additional_script_uri
  additional_script_name = local.additional_script_name

  run_command    = true
  rc_script_file = "scripts/windows_cis.ps1"


  tags = module.tags.common_tags

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

  vm_count = 2

  additional_script_uri  = "https://raw.githubusercontent.com/hmcts/CIS-harderning/master/windows-disk-mounting.ps1"
  additional_script_name = "windows-disk-mounting.ps1"
}