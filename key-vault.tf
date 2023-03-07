module "key-vault" {
  source                          = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                            = var.env == "prod" ? "${var.product}-hmctskv-${var.env}" : "${var.product}-${var.env}"
  product                         = var.product
  env                             = var.env
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  object_id                       = var.jenkins_AAD_objectId
  resource_group_name             = data.azurerm_resource_group.rg.name
  product_group_name              = "DTS Pre-recorded Evidence"
  common_tags                     = var.common_tags
  create_managed_identity         = true
  network_acls_allowed_subnet_ids = concat([data.azurerm_subnet.jenkins_subnet.id], [data.azurerm_subnet.pipelineagent_subnet.id], [data.azurerm_subnet.endpoint_subnet.id], [data.azurerm_subnet.datagateway_subnet.id], [data.azurerm_subnet.videoedit_subnet.id])
  purge_protection_enabled        = true
}
resource "azurerm_key_vault_access_policy" "jenkins_access" {
  key_vault_id       = module.key-vault.key_vault_id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  key_permissions    = ["List", "Update", "Create", "Import", "Delete", "Get", ]
  secret_permissions = ["List", "Set", "Delete", "Get", ]
  object_id          = var.jenkins_AAD_objectId
}

resource "azurerm_key_vault_access_policy" "power_app_access" {
  key_vault_id            = module.key-vault.key_vault_id
  object_id               = var.power_app_user_oid
  tenant_id               = data.azurerm_client_config.current.tenant_id
  key_permissions         = ["List", "Update", "Create", "Import", "Delete", "Get", ]
  certificate_permissions = ["List", "Update", "Create", "Import", "Delete", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", ]
  secret_permissions      = ["List", "Set", "Delete", "Get", ]
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

resource "azurerm_key_vault_secret" "vm_username" {
  count        = var.num_vid_edit_vms
  name         = "videditvm${count.index}-username"
  value        = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "vm_password" {
  count        = var.num_vid_edit_vms
  name         = "videditvm${count.index}-password"
  value        = random_password.vm_password[count.index].result
  key_vault_id = module.key-vault.key_vault_id
}

# Datagateway
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

resource "azurerm_key_vault_secret" "dtgtwy_username" {
  count        = var.num_datagateway
  name         = "Dtgtwy${count.index}-username"
  value        = "Dtgtwy${count.index}_${random_string.dtgtwy_username[count.index].result}"
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "dtgtwy_password" {
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
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
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

data "azurerm_key_vault" "keyvault" {
  name                = var.env == "prod" ? "${var.product}-hmctskv-${var.env}" : "${var.product}-${var.env}" #module.key-vault.key_vault_name
  resource_group_name = data.azurerm_resource_group.rg.name
  depends_on          = [module.key-vault]
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
