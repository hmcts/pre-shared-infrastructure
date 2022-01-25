# create the resource
resource "azurerm_private_endpoint" "blobprivateendpoint" {
  name                    = "${var.product}-pe-${var.name}"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  subnet_id               = azurerm_virtual_network.vnet.subnet.*.id[0]

  private_service_connection {
    name                              = "${var.product}-${var.name}-privateserviceconnection"
    private_connection_resource_id    = final_storage_account.storageaccount_name.id
    is_manual_connection              = false
    subresource_names                 = ["blob"]
  }
}

resource "azurerm_private_dns_zone" "privatelinkdns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

# # resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
# #   name                  = "vnet_link"
# #   resource_group_name   = azurerm_resource_group.rg.name
# #   private_dns_zone_name = azurerm_private_dns_zone.privatelinkdns.name
# #   virtual_network_id    = azurerm_virtual_network.example.id
# # }

# # resource "azurerm_private_dns_a_record" "dns_a" {
# #   name                = format("%s-%s", var.name, "arecord")
# #   zone_name           = var.private_dns_zone_name
# #   resource_group_name = azurerm_resource_group.rg.name
# #   ttl                 = 300
# #   records             = [azurerm_private_endpoint.endpoint.private_service_connection.0.private_ip_address]
# # }

# # # outputs
# # output "private_ip" {
# #   value = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
# # }