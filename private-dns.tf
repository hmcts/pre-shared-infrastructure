
resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  for_each = toset(var.private_dns_zones)

  provider = azurerm.private-dns
  name = format("%s%s",
    var.project,
    var.environment
  )
  resource_group_name   = "core-infra-intsvc-rg"
  private_dns_zone_name = each.key
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
  registration_enabled  = true
}

// private endpoint zones are only located in the prod subscription
resource "azurerm_private_dns_zone_virtual_network_link" "private_endpoint" {
  for_each = toset(var.private_endpoint_private_dns_zones)

  provider = azurerm.private-dns-private-endpoint
  name = format("%s%s",
    var.project,
    var.environment
  )
  resource_group_name   = "core-infra-intsvc-rg"
  private_dns_zone_name = each.key
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
}