module "edit_vm" {
  providers = {
    azurerm     = azurerm
    azurerm.cnp = azurerm.cnp
    azurerm.soc = azurerm.soc
  }
  count                          = var.num_vid_edit_vms
  source                         = "git@github.com:hmcts/terraform-module-virtual-machine.git?ref=master"
  env                            = var.env
  vm_type                        = local.edit_vm_type
  vm_name                        = "edit-vm${count.index + 1}-${var.env}"
  computer_name                  = "editvm${count.index + 1}${var.env}"
  vm_resource_group              = data.azurerm_resource_group.rg.name
  vm_location                    = var.location
  vm_size                        = local.edit_vm_size
  vm_admin_name                  = azurerm_key_vault_secret.edit_username[count.index].value
  vm_admin_password              = azurerm_key_vault_secret.edit_password[count.index].value
  vm_availabilty_zones           = local.edit_vm_availability_zones[count.index]
  managed_disks                  = var.edit_vm_data_disks[count.index]
  accelerated_networking_enabled = true
  custom_data                    = var.env == "prod" || var.env == "stg" ? filebase64("./scripts/edit-init.ps1") : filebase64("./scripts/edit-init-nonprod.ps1")
  privateip_allocation           = "Static"
  systemassigned_identity        = true
  vm_patch_assessment_mode       = null
  provision_vm_agent             = null
  vm_patch_mode                  = null
  aum_schedule_enable            = false

  os_disk_size_gb = 127

  nic_name      = lower("edit${count.index + 1}-nic-${var.env}")
  ipconfig_name = local.edit_ipconfig_name
  vm_subnet_id  = local.edit_vm_subnet_id
  vm_private_ip = var.edit_vm_private_ip[count.index]

  #storage_image_reference
  vm_publisher_name = local.edit_marketplace_publisher
  vm_offer          = local.edit_marketplace_product
  vm_sku            = local.edit_marketplace_sku
  vm_version        = local.edit_vm_version

  boot_diagnostics_enabled = local.edit_boot_diagnostics_enabled

  nessus_install    = false #var.nessus_install
  install_splunk_uf = false

  dynatrace_hostgroup = var.hostgroup
  dynatrace_server    = var.server
  dynatrace_tenant_id = var.tenant_id
  dynatrace_token     = try(data.azurerm_key_vault_secret.dynatrace-token.value, null)

  #mount the disks
  additional_script_uri  = local.edit_additional_script_uri
  additional_script_name = local.edit_additional_script_name

  run_command                  = true
  rc_script_file               = "scripts/windows_cis.ps1"
  custom_script_extension_name = "HMCTSVMBootstrap"
  tags                         = var.common_tags

}

locals {
  edit_vm_type = "windows"

  edit_vm_size       = "Standard_E2ds_v5"
  edit_ipconfig_name = "IP_CONFIGURATION"

  edit_vm_subnet_id = data.azurerm_subnet.videoedit_subnet.id

  edit_vm_availability_zones = [1, 2]
  edit_marketplace_product   = "Windows-10"
  edit_marketplace_publisher = "MicrosoftWindowsDesktop"
  edit_marketplace_sku       = "win10-22h2-pro-g2"
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

# resource "null_resource" "run_edit_script" {
#   count = var.num_vid_edit_vms
#   triggers = {
#     vm_id = module.edit_vm.*.vm_id[count.index]
#   }

#   provisioner "local-exec" {
#     command = <<EOT
#       az vm run-command invoke \
#         --ids "${module.edit_vm.*.vm_id[count.index]}" \
#         --command-id "RunPowerShellScript" \
#         --scripts @scripts/edit-init.ps1
#     EOT
#   }
# }


resource "azurerm_virtual_machine_extension" "edit_init" {
  count                = var.num_vid_edit_vms
  name                 = "toolingScript"
  virtual_machine_id   = module.edit_vm.*.vm_id[count.index]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = <<SETTINGS
 {
   "commandToExecute": "powershell -ExecutionPolicy unrestricted -NoProfile -NonInteractive -command \"cp c:/azuredata/customdata.bin c:/azuredata/edit-init.ps1; c:/azuredata/edit-init.ps1\""
 }
SETTINGS

  tags = var.common_tags
}

# DTS-PRE-VideoEditing-SecurityGroup-
resource "azurerm_role_assignment" "vm_contributor" {
  count                = var.num_vid_edit_vms
  scope                = module.edit_vm.*.vm_id[count.index]
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = data.azuread_group.edit_group.object_id
}

resource "azurerm_role_assignment" "vm_reader" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_group.edit_group.object_id
}

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
  name         = "videditvm${count.index + 1}-username"
  value        = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "edit_password" {
  count           = var.num_vid_edit_vms
  name            = "videditvm${count.index + 1}-password"
  value           = random_password.vm_password[count.index].result
  key_vault_id    = data.azurerm_key_vault.keyvault.id
  expiration_date = local.secret_expiry
}
