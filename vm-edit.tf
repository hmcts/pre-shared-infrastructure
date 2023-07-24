
resource "azurerm_key_vault_secret" "edit_password" {
  count        = var.num_vid_edit_vms
  name         = "videditvm${count.index}-password"
  value        = random_password.vm_password[count.index].result
  key_vault_id = data.azurerm_key_vault.pre_kv.id
}