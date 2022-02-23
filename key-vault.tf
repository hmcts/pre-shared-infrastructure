data "azurerm_client_config" "current" {}

module "key-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  product                 = var.product
  env                     = var.env
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = var.jenkins_AAD_objectId
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = "DTS Pre-recorded Evidence"
  common_tags             = var.common_tags
  create_managed_identity = true
}

// Power App Permissions
resource "azurerm_key_vault_access_policy" "power_app_access" {
  key_vault_id = module.key-vault.key_vault_id
  object_id    = var.power_app_user_oid
  tenant_id    = data.azurerm_client_config.current.tenant_id

  key_permissions = [
    "list",
    "update",
    "create",
    "import",
    "delete",
  ]

  certificate_permissions = [
    "list",
    "update",
    "create",
    "import",
    "delete",
    "managecontacts",
    "manageissuers",
    "getissuers",
    "listissuers",
    "setissuers",
    "deleteissuers",
  ]

  secret_permissions = [
    "list",
    "set",
    "delete",
  ]
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
  override_special = "_%@$"
}

resource "azurerm_key_vault_secret" "vm_username_secret" {
  count        = var.num_vid_edit_vms
  name         = "videditvm${count.index}-username"
  value        = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "vm_password_secret" {
  count        = var.num_vid_edit_vms
  name         = "videditvm${count.index}-password"
  value        = random_password.vm_password[count.index].result
  key_vault_id = module.key-vault.key_vault_id
}

###################################################
#                PRIVATE ENDPOINT                 #
###################################################
# resource "azurerm_private_endpoint" "endpoint" {
#   name                = local.endpoint_name
#   location            = var.strLocation
#   resource_group_name = var.rg_name
#   subnet_id           = var.virtual_network_subnet_ids

#   private_service_connection {
#     name                           = local.service_connection_name
#     private_connection_resource_id = azurerm_key_vault.vault.id
#     is_manual_connection           = var.is_manual_connection
#     subresource_names              = var.subResourceNames
#   }

#   private_dns_zone_group {
#     name                 = lower(var.vault_name)
#     private_dns_zone_ids = var.private_dns_zone_ids
#   }
# }
