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

# This is your API application that protects the APIM resource
resource "azuread_application" "api_app" {
  display_name    = data.azuread_application.pre_apim_b2c_app.display_name
  identifier_uris = ["api://${data.azuread_application.pre_apim_b2c_app.client_id}"]

  api {
    requested_access_token_version = 2

    # Delegated scope that the B2C app (pre-portal-sso) will request
    oauth2_permission_scope {
      id                         = random_uuid.scope_api_request_b2c.result
      value                      = "api.request.b2c"
      type                       = "Admin" # require admin consent
      enabled                    = true
      admin_consent_display_name = "PRE ${var.env} Request B2C"
      admin_consent_description  = "Allow the caller to perform B2C request operations."
      user_consent_display_name  = "PRE ${var.env} Request B2C"
      user_consent_description   = "Allow the caller to perform B2C request operations."
    }
  }
}
