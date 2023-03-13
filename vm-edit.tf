module "edit_vm" {
  count                          = var.num_vid_edit_vms
  source                         = "git@github.com:hmcts/terraform-vm-module.git?ref=master"
  vm_type                        = local.edit_vm_type
  vm_name                        = "edit-vm${count.index + 1}-${var.env}"
  vm_resource_group              = data.azurerm_resource_group.rg.name
  vm_location                    = var.location
  vm_size                        = local.edit_vm_size
  vm_admin_name                  = azurerm_key_vault_secret.edit_username[count.index].value
  vm_admin_password              = azurerm_key_vault_secret.edit_password[count.index].value
  vm_availabilty_zones           = local.edit_vm_availabilty_zones[count.index]
  managed_disks                  = var.edit_vm_data_disks[count.index]
  accelerated_networking_enabled = true

  #Disk Encryption
  kv_name     = "pre-${var.env}"
  kv_rg_name  = "pre-${var.env}"
  encrypt_ADE = true

  nic_name      = lower("edit${count.index + 1}-nic-${var.env}")
  ipconfig_name = local.edit_ipconfig_name
  vm_subnet_id  = local.edit_vm_subnet_id
  vm_private_ip = var.edit_vm_private_ip[count.index]

  marketplace_sku       = local.edit_marketplace_sku
  marketplace_publisher = local.edit_marketplace_publisher
  marketplace_product   = local.edit_marketplace_product

  #storage_image_reference
  vm_publisher_name = local.edit_marketplace_publisher
  vm_offer          = local.edit_marketplace_product
  vm_sku            = local.edit_marketplace_sku
  vm_version        = local.edit_vm_version

  boot_diagnostics_enabled = local.edit_boot_diagnostics_enabled

  nessus_install = false #var.nessus_install

  dynatrace_hostgroup = var.hostgroup
  dynatrace_server    = var.server
  dynatrace_tenant_id = var.tenant_id
  dynatrace_token     = try(data.azurerm_key_vault_secret.dynatrace-token.value, null)

  #mount the disks
  additional_script_uri  = local.edit_additional_script_uri
  additional_script_name = local.edit_additional_script_name

  run_command    = true
  rc_script_file = "scripts/windows_cis.ps1"


  tags = var.common_tags

}

locals {
  edit_vm_type = "windows"

  edit_vm_size       = "Standard_E4s_v4"
  edit_ipconfig_name = "IP_CONFIGURATION"

  edit_vm_subnet_id = data.azurerm_subnet.videoedit_subnet.id

  edit_vm_availabilty_zones  = [1, 2]
  edit_marketplace_product   = "Windows-10"
  edit_marketplace_publisher = "MicrosoftWindowsDesktop"
  edit_marketplace_sku       = "20h1-pro-g2"
  edit_vm_version            = "latest"

  edit_boot_diagnostics_enabled = false
  # boot_storage_uri         = data.azurerm_storage_account.db_boot_diagnostics_storage.primary_blob_endpoint

  edit_dynatrace_env = var.tenant_id == "yrk32651" ? "nonprod" : var.tenant_id == "ebe20728" ? "prod" : null

  edit_additional_script_uri  = "https://raw.githubusercontent.com/hmcts/CIS-harderning/master/windows-install.ps1"
  edit_additional_script_name = "windows-install.ps1"
}

resource "azurerm_virtual_machine_extension" "aad" {
  count                      = var.num_vid_edit_vms
  name                       = "AADLoginForWindows"
  virtual_machine_id         = module.edit_vm.*.vm_id[count.index]
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  tags                       = var.common_tags

}

resource "azurerm_virtual_machine_extension" "edit_init" {
  count                = var.num_vid_edit_vms
  name                 = "editCustomScript"
  virtual_machine_id   = module.edit_vm.*.vm_id[count.index]
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.0"

  settings = <<SETTINGS
 {
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File edit-init.ps1"

 }
SETTINGS


  tags = var.common_tags
}

# resource "azurerm_monitor_diagnostic_setting" "this" {
#   count                      = var.num_vid_edit_vms
#   name                       = azurerm_network_interface.nic[count.index].name
#   target_resource_id         = azurerm_network_interface.nic[count.index].id
#   log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

#   metric {
#     category = "AllMetrics"

#     retention_policy {
#       enabled = true
#       days    = 14
#     }
#   }
# }

// VM credentials
resource "random_string" "vm_username" {
  count   = var.num_vid_edit_vms
  length  = 4
  special = false
}

resource "random_password" "vm_password" {
  count            = var.num_vid_edit_vms
  length           = 16
  special          = true
  override_special = "#$%&@()_[]{}<>:?"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "edit_username" {
  count        = var.num_vid_edit_vms
  name         = "videditvm${count.index}-username"
  value        = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  key_vault_id = data.azurerm_key_vault.pre_kv.id
}

resource "azurerm_key_vault_secret" "edit_password" {
  count        = var.num_vid_edit_vms
  name         = "videditvm${count.index}-password"
  value        = random_password.vm_password[count.index].result
  key_vault_id = data.azurerm_key_vault.pre_kv.id
}