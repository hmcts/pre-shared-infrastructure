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