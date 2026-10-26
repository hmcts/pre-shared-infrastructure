# Lookups
data "azuread_application" "resource_app" {
  display_name = "pre-apim-b2c-${var.env}"
}
data "azuread_application" "client_app" {
  display_name = "pre-b2c-client-${var.env}"
}

data "azuread_service_principal" "resource_sp" {
  client_id = data.azuread_application.resource_app.client_id
}

data "azuread_service_principal" "client_sp" {
  client_id = data.azuread_application.client_app.client_id
}

# Grant the app role to the client
resource "azuread_app_role_assignment" "client_to_api" {
  principal_object_id = data.azuread_service_principal.client_sp.object_id
  app_role_id         = data.azuread_service_principal.resource_sp.app_role_ids["pre.api.request.b2c"]
  resource_object_id  = data.azuread_service_principal.resource_sp.object_id
}

# TEMPORARY Rotation - Need to confirm secret's actual use in future
resource "time_rotating" "b2c_client_secret_rotation" {
  rotation_days = 358 # ~rotate before expiry
}

# Create a client secret for client_credentials
resource "azuread_application_password" "client_secret" {
  end_date_relative = "8760h" # ~365 days
  application_id = data.azuread_application.client_app.id
  display_name   = "pre-b2c-client-${var.env}-client-secret"
  rotate_when_changed = {
    rotation = time_rotating.b2c_client_secret_rotation.id
  }
}

# Save client secret to Key Vault
resource "azurerm_key_vault_secret" "client_secret_kv" {
  name         = "pre-b2c-client-secret"
  value        = azuread_application_password.client_secret.value
  key_vault_id = data.azurerm_key_vault.keyvault.id

  # Use client secret expiration date to set the expiration date of the Key Vault secret
  expiration_date = azuread_application_password.client_secret.end_date
}