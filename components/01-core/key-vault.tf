data "azurerm_client_config" "current" {}

module "key-vault" {
  source                  = "git::https://github.com/hmcts/cnp-module-key-vault?ref=master"
  name                    = var.env == "prod" ? "${var.prefix}-hmctskv-${var.env}" : "${var.prefix}-${var.env}"
  product                 = var.prefix
  env                     = var.env
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  resource_group_name     = local.resource_group_name
  product_group_name      = "DTS Pre-recorded Evidence"
  common_tags             = module.tags.common_tags
  create_managed_identity = true
  //network_acls_allowed_subnet_ids = concat([azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id], [azurerm_subnet.videoeditvm_subnet.id])
  purge_protection_enabled = true
}

#####################################
#    DTS Pre-recorded Evidence | Members Access to KV
#####################################
resource "azurerm_key_vault_access_policy" "dts_pre_access" {
  key_vault_id = module.key-vault.key_vault_id
  # application_id        = var.app_id
  object_id               = var.dts_pre_oid
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = ["List", "Get", ]
  certificate_permissions = ["List", "Get", "GetIssuers", "ListIssuers", ]
  secret_permissions      = ["List", "Get", ]
  storage_permissions     = ["List", "Get", ]
}

#####################################
#    DTS CFT Developers| Members Access to KV
#####################################
resource "azurerm_key_vault_access_policy" "dts_cft_developers_access" {
  key_vault_id = module.key-vault.key_vault_id
  # application_id        = var.app_id
  object_id               = var.dts_cft_developers_oid
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = ["List", "Get", ]
  certificate_permissions = ["List", "Get", "GetIssuers", "ListIssuers", ]
  secret_permissions      = ["List", "Get", ]
  storage_permissions     = ["List", "Get", ]

}

#####################################
#    DTS PRE Admin
#####################################
# resource "azurerm_key_vault_access_policy" "dts_dts_pre_project_admin_access" {
#   key_vault_id = module.key-vault.key_vault_id
#   # application_id        = var.app_id
#   object_id               = var.dts_pre_project_admin
#   tenant_id               = data.azurerm_client_config.current.tenant_id
#   key_permissions         = ["List", "Get", ]
#   certificate_permissions = ["List", "Get", "GetIssuers", "ListIssuers", ]
#   secret_permissions      = ["List", "Get", ]
#   storage_permissions     = ["List", "Get", ]
# }

# // Access for the service connection App registrations dts_pre_<env>
# resource "azurerm_key_vault_access_policy" "appreg_access" {
#   key_vault_id = module.key-vault.key_vault_id
#   # application_id        = var.app_id
#   object_id          = var.dts_pre_appreg_oid
#   tenant_id          = data.azurerm_client_config.current.tenant_id
#   secret_permissions = ["List", "Get", ]
# }


data "azurerm_key_vault" "keyvault" {
  name                = var.env == "prod" ? "${var.prefix}-hmctskv-${var.env}" : "${var.prefix}-${var.env}" #module.key-vault.key_vault_name
  resource_group_name = data.azurerm_resource_group.rg.id

  depends_on = [module.key-vault]
}

### Dynatrace
data "azurerm_key_vault_secret" "dynatrace-token" {
  name         = "dynatrace-token"
  key_vault_id = module.key-vault.key_vault_id

  depends_on = [module.key-vault]
}

data "azurerm_key_vault_secret" "dynatrace-tenant-id" {
  name         = "dynatrace-tenant-id"
  key_vault_id = module.key-vault.key_vault_id

  depends_on = [module.key-vault]
}

#################################
##  Disk Encryption 
###############################

resource "azurerm_key_vault_key" "pre_kv_key" {
  name         = "pre-des-key"
  key_vault_id = module.key-vault.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

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
  name                = "pre-des-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.id
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.pre_kv_key.id
  identity {
    type = "SystemAssigned"
  }
  tags = module.tags.common_tags
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