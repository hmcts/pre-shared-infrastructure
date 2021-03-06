data "azurerm_client_config" "current" {}

module "key-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = var.env == "prod" ? "${var.product}-hmctskv-${var.env}" : "${var.product}-${var.env}"
  product                 = var.product
  env                     = var.env
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = var.jenkins_AAD_objectId
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = "DTS Pre-recorded Evidence"
  common_tags             = var.common_tags
  create_managed_identity = true
  network_acls_allowed_subnet_ids = concat([data.azurerm_subnet.jenkins_subnet.id],[azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id],[azurerm_subnet.videoeditvm_subnet.id])
  purge_protection_enabled    = true
  network_acls_default_action = "Deny"
  network_acls_allowed_ip_ranges = [ "80.44.26.160" ]
}

// Power App Permissions
resource "azurerm_key_vault_access_policy" "power_app_access" {
  key_vault_id = module.key-vault.key_vault_id
  object_id    = var.power_app_user_oid
  tenant_id    = data.azurerm_client_config.current.tenant_id
  key_permissions         = [ "List", "Update", "Create", "Import", "Delete", "Get", ]
  certificate_permissions = [ "List", "Update", "Create", "Import", "Delete", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", ]
  secret_permissions      = [ "List", "Set", "Delete", "Get", ]
}


#####################################
#    DTS Pre-recorded Evidence | Members Access to KV
#####################################
resource "azurerm_key_vault_access_policy" "dts_pre_access" {
  key_vault_id            = module.key-vault.key_vault_id
  # application_id        = var.app_id
  object_id               = var.dts_pre_oid 
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = [ "List","Get",]
  certificate_permissions = [ "List", "Get", "GetIssuers", "ListIssuers", ]
  secret_permissions      = [ "List", "Get", ]
  storage_permissions     = [ "List", "Get", ]
}

#####################################
#    DTS CFT Developers| Members Access to KV
#####################################
resource "azurerm_key_vault_access_policy" "dts_cft_developers_access" {
  key_vault_id            = module.key-vault.key_vault_id
  # application_id        = var.app_id
  object_id               = var.dts_cft_developers_oid
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = [ "List","Get",]
  certificate_permissions = [ "List", "Get", "GetIssuers", "ListIssuers", ]
  secret_permissions      = [ "List", "Get", ]
  storage_permissions     = [ "List", "Get", ]

}

#####################################
#    DTS PRE Admin
#####################################
resource "azurerm_key_vault_access_policy" "dts_dts_pre_project_admin_access" {
  key_vault_id            = module.key-vault.key_vault_id
  # application_id        = var.app_id
  object_id               = var.dts_pre_project_admin
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = [ "List","Get",]
  certificate_permissions = [ "List", "Get", "GetIssuers", "ListIssuers", ]
  secret_permissions      = [ "List", "Get", ]
  storage_permissions     = [ "List", "Get", ]
}


// DevopsAdmin Permissions
resource "azurerm_key_vault_access_policy" "devops_access" {
  key_vault_id            = module.key-vault.key_vault_id
  # application_id        = var.app_id
  object_id               = var.devops_admin
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = [ "List", "Update", "Create", "Import", "Delete", "Get" ]
  certificate_permissions = [ "List", "Update", "Create", "Import", "Delete", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", ]
  secret_permissions      = [ "List", "Set", "Delete", "Get", ]
  storage_permissions     = [ "List", "Set", "Delete", "Get", ]
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
  min_upper = 1
  min_lower = 1
  min_numeric = 1
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




#################################
##  Disk Encryption 
###############################

resource "azurerm_key_vault_key" "pre_kv_key" {
  name         = "pre-des-key"
  key_vault_id = module.key-vault.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  # depends_on = [
  #   azurerm_key_vault_access_policy.pre-kv-user
  # ]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "pre-des" {
  name                = "pre-des"#"pre-des-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  key_vault_key_id    = azurerm_key_vault_key.pre_kv_key.id
  identity {
    type = "SystemAssigned"
  }
  tags                = var.common_tags
}

resource "azurerm_key_vault_access_policy" "pre-des-disk" {
  key_vault_id = module.key-vault.key_vault_id

  tenant_id = azurerm_disk_encryption_set.pre-des.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.pre-des.identity.0.principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
}

# # ###################################################
# # #                MI access & permission               #
# # ###################################################
# # #Storage Blob Data Contributor Role Assignment for Managed Identity

# resource "azurerm_role_assignment" "pre_amsblobdatacontributor_mi" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Storage Blob Data Contributor"
#   principal_id                     = module.key-vault.managed_identity_objectid
#   skip_service_principal_aad_check = true
# }

# #Reader Role Assignment for Managed Identity
# resource "azurerm_role_assignment" "pre_amsreader_mi" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Reader"
#   principal_id                     = module.key-vault.managed_identity_objectid
#   skip_service_principal_aad_check = true
  
# }

# TODO

# ###################################################
# #                PRIVATE ENDPOINT                 #
# ###################################################

# resource "azurerm_private_endpoint" "keyvault_endpt" {
#   name                     = "${var.product}kv-pe${var.env}"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   subnet_id                = azurerm_subnet.endpoint_subnet.id

#   private_service_connection {
#     name                           = "${var.product}kv-psc${var.env}"
#     is_manual_connection           = false
#     private_connection_resource_id = module.key-vault.key_vault_id
#     subresource_names              = ["Vault"]
#   }
# tags = var.common_tags
# }
# TODO

  #   private_dns_zone_group {
  #     name                 = lower(var.vault_name)
  #     private_dns_zone_ids = var.private_dns_zone_ids
  #   }
  # }
  # TODO
  ###################################################
# #                PRIVATE ENDPOINT                 #
# ###################################################
  # network_acls {
  #   bypass                     = "AzureServices"
  #   default_action             = "Deny"
  #   virtual_network_subnet_ids = [azurerm_subnet.endpoint_subnet.id, azurerm_subnet.videoeditvm_subnet.id, azurerm_subnet.datagateway_subnet.id]
  #   ip_rules                   = []
  #  }
