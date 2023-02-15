module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = var.prefix
  builtFrom   = var.builtFrom
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.env}"
  location = var.location
  tags     = module.tags.common_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]

  tags = module.tags.common_tags
}

resource "azurerm_subnet" "datagateway_subnet" {
  name                 = "${var.prefix}-datagateway-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.data_gateway_snet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
}

resource "azurerm_subnet" "videoedit_subnet" {
  name                 = "${var.prefix}-videoedit-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.video_edit_vm_snet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
}

resource "azurerm_subnet" "endpoint_subnet" {
  name                 = "${var.prefix}-privatendpt-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.privatendpt_snet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
  # enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "AzureBastionSubnet_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastion_snet_address]
}

# connect data gateway vnet to private dns zone (this will contain the A name for postgres)
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dg" {
  provider              = azurerm.private_dns
  name                  = format("%s-%s-virtual-network-link", var.prefix, var.env)
  resource_group_name   = var.DNSResGroup
  private_dns_zone_name = var.PrivateDNSZone
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_route_table" "postgres" {
  name                          = "${var.prefix}-${var.env}-route-table"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.hub[local.hub_name].ukSouth.next_hop_ip
  }

  tags = module.tags.common_tags
}

resource "azurerm_subnet_route_table_association" "dg_subnet" {
  subnet_id      = azurerm_subnet.datagateway_subnet.id
  route_table_id = azurerm_route_table.postgres.id
}


resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-bastionpip-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = module.tags.common_tags
}

resource "azurerm_bastion_host" "bastion" {
  name                   = "${var.prefix}-bastion-${var.env}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = var.location
  copy_paste_enabled     = true
  file_copy_enabled      = true
  sku                    = "Standard"
  ip_connect_enabled     = true
  scale_units            = 2
  shareable_link_enabled = true
  tunneling_enabled      = true

  ip_configuration {
    name                 = "bastionpublic"
    subnet_id            = azurerm_subnet.AzureBastionSubnet_subnet.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  tags = module.tags.common_tags

}