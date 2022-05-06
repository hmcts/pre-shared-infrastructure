data "azurerm_client_config" "current" {}

# data "azurerm_user_assigned_identity" "pre-identity" {
#  name                     = "${var.product}-${var.env}-mi"
#  resource_group_name      = "managed-identities-${var.env}-rg"
#  common_tags              = var.common_tags
# }


module "key-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=kv_networkacls"
  name                    = "${var.product}-${var.env}" 
  product                 = var.product
  env                     = var.env
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = var.jenkins_AAD_objectId
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = "DTS Pre-recorded Evidence"
  common_tags             = var.common_tags
  create_managed_identity = true
  network_acls_allowed_subnet_id = concat([data.azurerm_subnet.jenkins_subnet.id],[azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id],[azurerm_subnet.videoeditvm_subnet.id])
  # purge_protection_enabled    = true

}

// Power App Permissions
resource "azurerm_key_vault_access_policy" "power_app_access" {
  key_vault_id            = module.key-vault.key_vault_id
  object_id               = var.power_app_user_oid
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = [ "List", "Update", "Create", "Import", "Delete", "Get", ]
  certificate_permissions = [ "List", "Update", "Create", "Import", "Delete", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", ]
  secret_permissions      = [ "List", "Set", "Delete", "Get", ]

  depends_on = [ module.key-vault]

}


# // Jenkins management Permissions
# resource "azurerm_key_vault_access_policy" "jenkins_access" {
#   key_vault_id            = module.key-vault.key_vault_id
#   # application_id        = var.app_id
#   object_id               = "7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01" 
#   tenant_id               = data.azurerm_client_config.current.tenant_id
#   key_permissions         = [ "List", "Update", "Create", "Import", "Delete", "Get" ]
#   certificate_permissions = [ "List", "Update", "Create", "Import", "Delete", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", ]
#   secret_permissions      = [ "List", "Set", "Delete", "Get", ]
#   storage_permissions     = [ "List", "Set", "Delete", "Get", ]
# }

# #####################################
# #    Managed Identity Access to KV
# #####################################
# resource "azurerm_key_vault_access_policy" "mi_access" {
#   key_vault_id            = module.key-vault.key_vault_id
#   # application_id        = var.app_id
#   object_id               = var.managed_oid
#   tenant_id               = data.azurerm_client_config.current.tenant_id
#   key_permissions         = [ "List","Update","Create","Import","Delete", "Get",]
#   certificate_permissions = [ "List", "Get", "GetIssuers", "ListIssuers", ]
#   secret_permissions      = [ "List", "Set", "Delete", "Get", ]
#   storage_permissions     = [ "List", "Set", "Delete", "Get", ]
# }

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
resource "azurerm_key_vault_access_policy" "dts_pre_app_admin_access" {
  key_vault_id            = module.key-vault.key_vault_id
  # application_id        = var.app_id
  object_id               = var.dts_pre_app_admin  
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

# #####################################
# #    Managed Identity Access to KV
# #####################################
# module "claim-store-vault" { 
#   source                      = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
#   #...
#   product                     = var.product
#   env                         = var.env
#   resource_group_name         = azurerm_resource_group.rg.name
#   managed_identity_object_ids = [data.azurerm_user_assigned_identity.pre-identity.principal_id]
#   common_tags                 = var.common_tags
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

resource "random_string" "dtgtwy_username" {
  count   = var.num_datagateway
  length  = 4
  special = false
}

resource "random_password" "dtgtwy_password" {
  count            = var.num_datagateway
  length           = 16
  special          = true
  override_special = "$%&@()-_=+[]{}<>:?"
  min_upper = 1
  min_lower = 1
  min_numeric = 1
}

resource "azurerm_key_vault_secret" "dtgtwy_username_secret" {
  count        = var.num_datagateway
  name         = "Dtgtwy${count.index}-username"
  value        = "Dtgtwy${count.index}_${random_string.dtgtwy_username[count.index].result}"
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "dtgtwy_password_secret" {
  count        = var.num_datagateway
  name         = "Dtgtwy${count.index}-password"
  value        = random_password.dtgtwy_password[count.index].result
  key_vault_id = module.key-vault.key_vault_id
}




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
