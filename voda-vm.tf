module "virtual_machine" {
  providers = {
    azurerm     = azurerm
    azurerm.cnp = azurerm.cnp
    azurerm.soc = azurerm.soc
    azurerm.dcr = azurerm.dcr
  }
  count                = var.num_voda_vms
  source               = "git@github.com:hmcts/terraform-module-virtual-machine.git?ref=master"
  env                  = var.env
  vm_type              = "linux"
  vm_name              = "voda-vm"
  vm_resource_group    = data.azurerm_resource_group.rg.name
  vm_admin_name        = azurerm_key_vault_secret.voda_username[count.index].value
  vm_admin_password    = azurerm_key_vault_secret.voda_password[count.index].value
  vm_subnet_id         = local.edit_vm_subnet_id
  vm_private_ip        = var.voda_vm_private_ip[count.index]
  vm_publisher_name    = "canonical"
  vm_offer             = "0001-com-ubuntu-server-jammy"
  vm_sku               = "22_04-lts-gen2"
  vm_size              = "Standard_D2ds_v5"
  vm_version           = "latest"
  vm_availabilty_zones = "1"
  tags                 = var.common_tags
}

resource "azurerm_key_vault_secret" "voda_username" {
  count        = var.num_voda_vms
  name         = "vodavm${count.index + 1}-username"
  value        = "voda${count.index}_${random_string.vm_username[count.index].result}"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}


resource "azurerm_key_vault_secret" "voda_password" {
  count        = var.num_voda_vms
  name         = "vodavm${count.index + 1}-password"
  value        = random_password.vm_password[count.index].result
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
