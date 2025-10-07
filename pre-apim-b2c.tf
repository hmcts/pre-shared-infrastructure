resource "random_uuid" "scope_api_request_b2c" {}

import {
  to = azuread_application.api_app
  id = "/applications/${var.pre_apim_b2c_app_object_id}"
}

check "app_import_matches_lookup" {
  assert {
    condition     = data.azuread_application.pre_apim_b2c_app.object_id == var.pre_apim_b2c_app_object_id
    error_message = "api_app_object_id does not match the object for '${var.product}-apim-b2c-${var.env}'."
  }
}

resource "azuread_application" "api_app" {
  display_name    = data.azuread_application.pre_apim_b2c_app.display_name
  identifier_uris = ["api://${data.azuread_application.pre_apim_b2c_app.client_id}"]

  api {
    requested_access_token_version = 2

    # Delegated scope (appears in 'scp')
    oauth2_permission_scope {
      id                         = random_uuid.scope_api_request_b2c.result
      value                      = "api.request.b2c"
      type                       = "Admin" # require admin consent; use "User" if self-consent is OK
      enabled                    = true
      admin_consent_display_name = "PRE ${var.env} Request B2C"
      admin_consent_description  = "Allow the caller to perform B2C request operations."
      user_consent_display_name  = "PRE ${var.env} Request B2C"
      user_consent_description   = "Allow the caller to perform B2C request operations."
    }
  }
}

# --- declare the API permission on the client (delegated scope) ---
resource "azuread_application_api_access" "client_needs_api" {
  application_id = data.azuread_application.pre_apim_b2c_app.client_id
  api_client_id  = azuread_application.api_app.client_id
  scope_ids = [
    azuread_application.api_app.oauth2_permission_scope_ids["api.request.b2c"]
  ]
}

# # --- admin consent for that client (required since scope type = "Admin") ---
# resource "azuread_service_principal_delegated_permission_grant" "client_consent" {
#   service_principal_object_id          = data.azuread_application.pre_apim_b2c_app.object_id
#   resource_service_principal_object_id = azuread_service_principal.resource_api_sp.object_id
#   consent_type                         = "AllPrincipals"
#   claim_values                         = ["api.request.b2c"]
# }