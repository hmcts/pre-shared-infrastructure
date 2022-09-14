#Create Azure Network Security Group With The Appropriate Security Rules
resource "azurerm_network_security_group" "bastionnsg" {
  name                          = "${var.product}-nsg-${var.env}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name

    security_rule {
        name                       = "AllowHttpsInbound"
        priority                   = 120
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "AllowGatewayManagerInbound"
        priority                   = 130
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "GatewayManager"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "AllowAzureLoadBalancerInbound"
        priority                   = 140
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "AzureLoadBalancer"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "AllowBastionHostCommunication1"
        priority                   = 150
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     ="8080"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "AllowBastionHostCommunication2"
        priority                   = 160
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     ="5701"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "AllowSshRdpOutbound1"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     ="22"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
    }


    security_rule {
        name                       = "AllowSshRdpOutbound2"
        priority                   = 110
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     ="3389"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
    }

    security_rule {
        name                       = "AllowAzureCloudOutbound"
        priority                   = 120
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "AzureCloud"
    }

    security_rule {
        name                       = "AllowBastionCommunication1"
        priority                   = 130
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
    }

    security_rule {
        name                       = "AllowBastionCommunication2"
        priority                   = 140
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range    = "5701"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
    }

    security_rule {
        name                       = "AllowGetSessionInformation"
        priority                   = 150
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "Internet"
    }

}


#Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsgassoc" {
    count                     = var.num_vid_edit_vms
    network_interface_id      = "${azurerm_network_interface.nic.[count.index].id}"
    network_security_group_id = azurerm_network_security_group.bastionnsg.id

    depends_on = [
      azurerm_windows_virtual_machine.vm
    ]
    }