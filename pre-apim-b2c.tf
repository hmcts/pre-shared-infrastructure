# Lookups
data "azuread_application" "resource_app" {
  display_name = "pre-apim-b2c-${var.env}" # your protected API
}
data "azuread_application" "client_app" {
  display_name = "pre-b2c-client-${var.env}" # B2C will use this
}

# Import the existing resource app into state
import {
  to = azuread_application.resource_api
  id = "/applications/${var.pre_apim_b2c_app_object_id}" # OBJECT ID of pre-apim-b2c-${var.env}
}

# Sanity check
check "import_matches_lookup" {
  assert {
    condition     = data.azuread_application.resource_app.object_id == var.pre_apim_b2c_app_object_id
    error_message = "Object ID does not match pre-apim-b2c-${var.env}."
  }
}

# Stable ID for the app role
resource "random_uuid" "app_role" {}

# Resource app
resource "azuread_application" "resource_api" {
  display_name    = data.azuread_application.resource_app.display_name
  identifier_uris = ["api://${data.azuread_application.resource_app.client_id}"] # keep existing audience
  api { requested_access_token_version = 2 }

  app_role {
    id                   = random_uuid.app_role.result
    value                = "pre.api.request.b2c"
    display_name         = "PRE ${var.env} Request B2C (app)"
    description          = "App-only access for 2FA / Forgotten login relay via APIM."
    allowed_member_types = ["Application"]
    enabled              = true
  }
}

# Ensure SPs exist
resource "azuread_service_principal" "resource_sp" {
  client_id = data.azuread_application.resource_app.client_id
}
resource "azuread_service_principal" "client_sp" {
  client_id = data.azuread_application.client_app.client_id
}

# Grant the app role to the client (this is the "admin consent" for app perms)
resource "azuread_service_principal_app_role_assignment" "client_to_api" {
  service_principal_object_id          = azuread_service_principal.client_sp.object_id
  resource_service_principal_object_id = azuread_service_principal.resource_sp.object_id
  app_role_id                          = azuread_service_principal.resource_sp.app_role_ids["pre.api.request.b2c"]
  depends_on                           = [azuread_application.resource_api]
}

# Create a client secret for client_credentials
resource "azuread_application_password" "client_secret" {
  application_id = data.azuread_application.client_app.id
  display_name   = "pre-b2c-client-${var.env}-client-secret"
  end_date       = "2026-10-28T00:00:00Z"
}

# Save client secret to Key Vault
resource "azurerm_key_vault_secret" "client_secret_kv" {
  name         = "pre-b2c-client-secret"
  value        = azuread_application_password.client_secret.value
  key_vault_id = data.azurerm_key_vault.keyvault.id
}