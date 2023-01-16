data "azurerm_client_config" "current" {}

module "key-vault" {
  source                          = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                            = var.env == "prod" ? "${var.product}-hmctskv-${var.env}" : "${var.product}-${var.env}"
  product                         = var.product
  env                             = var.env
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  object_id                       = var.jenkins_AAD_objectId
  resource_group_name             = azurerm_resource_group.rg.name
  product_group_name              = "DTS Pre-recorded Evidence"
  common_tags                     = var.common_tags
  create_managed_identity         = true
  network_acls_allowed_subnet_ids = concat([data.azurerm_subnet.jenkins_subnet.id], [data.azurerm_subnet.pipelineagent_subnet.id], [azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id], [azurerm_subnet.videoeditvm_subnet.id])
  purge_protection_enabled        = true
  network_acls_default_action     = "Deny"
  network_acls_allowed_ip_ranges  = ["80.44.26.160", "86.179.180.2"]
}

// Power App Permissions
resource "azurerm_key_vault_access_policy" "power_app_access" {
  key_vault_id            = module.key-vault.key_vault_id
  object_id               = var.power_app_user_oid
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = ["List", "Update", "Create", "Import", "Delete", "Get", ]
  certificate_permissions = ["List", "Update", "Create", "Import", "Delete", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", ]
  secret_permissions      = ["List", "Set", "Delete", "Get", ]
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
resource "azurerm_key_vault_access_policy" "dts_dts_pre_project_admin_access" {
  key_vault_id = module.key-vault.key_vault_id
  # application_id        = var.app_id
  object_id               = var.dts_pre_project_admin
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = ["List", "Get", ]
  certificate_permissions = ["List", "Get", "GetIssuers", "ListIssuers", ]
  secret_permissions      = ["List", "Get", ]
  storage_permissions     = ["List", "Get", ]
}


// DevopsAdmin Permissions
resource "azurerm_key_vault_access_policy" "devops_access" {
  key_vault_id = module.key-vault.key_vault_id
  # application_id        = var.app_id
  object_id               = var.devops_admin
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = ["List", "Update", "Create", "Import", "Delete", "Get"]
  certificate_permissions = ["List", "Update", "Create", "Import", "Delete", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", ]
  secret_permissions      = ["List", "Set", "Delete", "Get", ]
  storage_permissions     = ["List", "Set", "Delete", "Get", ]
}

// Access for the service connection App registrations dts_pre_<env>
resource "azurerm_key_vault_access_policy" "appreg_access" {
  key_vault_id = module.key-vault.key_vault_id
  # application_id        = var.app_id
  object_id          = var.dts_pre_appreg_oid
  tenant_id          = data.azurerm_client_config.current.tenant_id
  secret_permissions = ["List", "Get", ]
}

## Datagateway


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
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
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
  name                = "pre-des" #"pre-des-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  key_vault_key_id    = azurerm_key_vault_key.pre_kv_key.id
  identity {
    type = "SystemAssigned"
  }
  tags = var.common_tags
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



### Dynatrace


# data "azurerm_key_vault" "keyvault" {
#   name                = module.key-vault.key_vault_name
#   resource_group_name = azurerm_resource_group.rg.name
# }



data "azurerm_key_vault" "keyvault" {
  name                = var.env == "prod" ? "${var.product}-hmctskv-${var.env}" : "${var.product}-${var.env}" #module.key-vault.key_vault_name
  resource_group_name = azurerm_resource_group.rg.name
}

### Dynatrace
data "azurerm_key_vault_secret" "dynatrace-token" {
  name         = "dynatrace-token"
  key_vault_id = module.key-vault.key_vault_id
}

data "azurerm_key_vault_secret" "dynatrace-tenant-id" {
  name         = "dynatrace-tenant-id"
  key_vault_id = module.key-vault.key_vault_id
}