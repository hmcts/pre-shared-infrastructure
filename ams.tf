resource "azurerm_private_dns_zone_virtual_network_link" "ams_zone_link" {
  count                 = var.env != "test" ? 1 : 0
  provider              = azurerm.private_dns
  name                  = format("%s-%s-virtual-network-link", var.product, var.env)
  resource_group_name   = var.dns_resource_group
  private_dns_zone_name = "privatelink.media.azure.net"
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}
