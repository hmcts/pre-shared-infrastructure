# Lookups
data "azuread_application" "resource_app" {
  display_name = "pre-apim-b2c-${var.env}"
}
data "azuread_application" "client_app" {
  display_name = "pre-b2c-client-${var.env}"
}

data "azuread_service_principal" "client_sp" {
  client_id = data.azuread_application.client_app.client_id
}

# Grant the app role to the client
resource "azuread_app_role_assignment" "client_to_api" {
  principal_object_id = data.azuread_service_principal.client_sp.object_id
  app_role_id         = data.azuread_application.resource_app.app_role_ids[0]
  resource_object_id  = data.azuread_application.resource_app.object_id
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