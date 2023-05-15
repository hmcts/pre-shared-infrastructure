resource "azurerm_network_security_group" "dg_nsg" {
  name                = "dg-nsg-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "dg_allow_outbound" {
  name              = "dg_allow_outbound"
  priority          = 1000
  direction         = "Outbound"
  access            = "Allow"
  protocol          = "Tcp"
  source_port_range = "*"
  destination_port_ranges = [
    "443",
    "5671",
    "5672",
    "9350-9354",
  ]
  source_address_prefix       = var.data_gateway_snet_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.dg_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "dg_subnet_nsg" {
  subnet_id                 = azurerm_subnet.datagateway_subnet.id
  network_security_group_id = azurerm_network_security_group.dg_nsg.id
}