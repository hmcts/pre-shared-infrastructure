resource "random_uuid" "b2c_audience" {}
resource "random_uuid" "scope_api_request_b2c" {}
resource "random_uuid" "scope_api_app_role" {}

resource "azuread_application" "b2c_api" {
  provider     = azuread.b2c
  display_name = "${var.product}-b2c-api-${var.env}"
  identifier_uris = ["api://${random_uuid.b2c_audience.result}"]

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      id                         = random_uuid.scope_api_request_b2c.result
      value                      = "api.request.b2c"
      type                       = "Admin"
      enabled                    = true
      admin_consent_display_name = "Request B2C"
      admin_consent_description  = "Allow B2C request operations."
      user_consent_display_name  = "Request B2C"
      user_consent_description   = "Allow B2C request operations."
    }
  }

  app_role {
    id                   = random_uuid.scope_api_app_role.result
    value                = "api.request.b2c"
    display_name         = "Request B2C (app)"
    description          = "App-only access to send 2FA emails via pre-api behind APIm."
    allowed_member_types = ["Application"]
    enabled              = true
  }
}

data "azuread_application" "b2c_client" {
  provider     = azuread.b2c
  display_name = "${var.product}-portal-sso"
}

# # Prefer pre-authorization (B2C way to trust first-party clients)
# resource "azuread_application_pre_authorized" "b2c_pre_auth" {
#   provider               = azuread.b2c
#   application_object_id  = azuread_application.b2c_api.object_id
#   authorized_client_id   = data.azuread_application.b2c_client.client_id
#   permission_ids         = [random_uuid.scope_api_request_b2c.result]
# }