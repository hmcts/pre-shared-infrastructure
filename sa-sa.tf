module "sa_storage_account" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.product}sa${var.env}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  allow_nested_items_to_be_public = true
  default_action                  = "Allow"
  enable_data_protection          = true
  restore_policy_days             = var.restore_policy_days
  enable_change_feed              = true
  managed_identity_object_id      = data.azurerm_user_assigned_identity.managed_identity.principal_id
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id], [data.azurerm_subnet.endpoint_subnet.id], [data.azurerm_subnet.datagateway_subnet.id], [data.azurerm_subnet.videoedit_subnet.id])
  private_endpoint_subnet_id      = data.azurerm_subnet.endpoint_subnet.id
  containers                      = local.containers
  cors_rules = [{
    allowed_headers    = ["*"]
    allowed_methods    = ["GET", "OPTIONS"]
    allowed_origins    = ["https://hmctsdevextid.b2clogin.com"]
    exposed_headers    = ["*"]
    max_age_in_seconds = 200
  }]

  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  common_tags = var.common_tags
}

# Store the connection string for the SAs in KV
resource "azurerm_key_vault_secret" "sa_storage_account_connection_string" {
  name         = "sa-storage-account-connection-string"
  value        = module.sa_storage_account.storageaccount_primary_connection_string
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_monitor_diagnostic_setting" "storageblobsa" {
  name                       = module.sa_storage_account.storageaccount_name
  target_resource_id         = "${module.sa_storage_account.storageaccount_id}/blobServices/default"
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id
  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
  }
  metric {
    category = "Capacity"
    enabled  = false
  }
}

resource "azurerm_storage_blob" "b2c_login_html" {
  name                   = "login.html"
  content_type           = "text/html"
  content_md5            = filemd5("./b2c/login.html")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/login.html"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_main_css" {
  name                   = "main.css"
  content_type           = "text/css"
  content_md5            = filemd5("./b2c/main.css")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/main.css"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_copyright_png" {
  name                   = "copyright.png"
  content_type           = "image/x-png"
  content_md5            = filemd5("./b2c/copyright.png")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/copyright.png"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_favicon" {
  name                   = "favicon.ico"
  content_type           = "image/x-icon"
  content_md5            = filemd5("./b2c/favicon.ico")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/favicon.ico"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_logo_gov" {
  name                   = "logo_gov.png"
  content_type           = "image/x-png"
  content_md5            = filemd5("./b2c/logo_gov.png")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/logo_gov.png"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_mfa_html" {
  name                   = "mfa.html"
  content_type           = "text/html"
  content_md5            = filemd5("./b2c/mfa.html")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/mfa.html"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_mfa_css" {
  name                   = "mfa.css"
  content_type           = "text/css"
  content_md5            = filemd5("./b2c/mfa.css")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/mfa.css"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_font_bold_v2_woff" {
  name                   = "bold-affa96571d-v2.woff"
  content_type           = "application/octet-stream"
  content_md5            = filemd5("./b2c/bold-affa96571d-v2.woff")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/bold-affa96571d-v2.woff"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_font_bold_v2_2_woff2" {
  name                   = "bold-b542beb274-v2.woff2"
  content_type           = "application/octet-stream"
  content_md5            = filemd5("./b2c/bold-b542beb274-v2.woff2")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/bold-b542beb274-v2.woff2"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_font_light_v2_woff" {
  name                   = "light-f591b13f7d-v2.woff"
  content_type           = "application/octet-stream"
  content_md5            = filemd5("./b2c/light-f591b13f7d-v2.woff")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/light-f591b13f7d-v2.woff"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_font_light_v2_2_woff2" {
  name                   = "light-94a07e06a1-v2.woff2"
  content_type           = "application/octet-stream"
  content_md5            = filemd5("./b2c/light-94a07e06a1-v2.woff2")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/light-94a07e06a1-v2.woff2"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_govuk_crest_2x_png" {
  name                   = "govuk-crest-2x.png"
  content_type           = "image/x-png"
  content_md5            = filemd5("./b2c/govuk-crest-2x.png")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/govuk-crest-2x.png"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_govuk_crest_png" {
  name                   = "govuk-crest.png"
  content_type           = "image/x-png"
  content_md5            = filemd5("./b2c/govuk-crest.png")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/govuk-crest.png"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_govuk_icon_180_png" {
  name                   = "govuk-icon-180.png"
  content_type           = "image/x-png"
  content_md5            = filemd5("./b2c/govuk-icon-180.png")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/govuk-icon-180.png"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_favicon_svg" {
  name                   = "favicon.svg"
  content_type           = "image/svg+xml"
  content_md5            = filemd5("./b2c/favicon.svg")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/favicon.svg"

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_icon_mask_svg" {
  name                   = "govuk-icon-mask.svg"
  content_type           = "image/svg+xml"
  content_md5            = filemd5("./b2c/govuk-icon-mask.svg")
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = "./b2c/govuk-icon-mask.svg"

  depends_on = [module.sa_storage_account]
}