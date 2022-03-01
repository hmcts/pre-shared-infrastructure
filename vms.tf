resource "azurerm_public_ip" "pip" {
   name                = "${var.product}-pip-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

###################################################
#            NETWORK INTERFACE CARD               #
###################################################
# resource "azurerm_network_interface" "nic" {
#   count               = var.num_vid_edit_vms
#   name                = "${var.product}-videditvmnic${count.index}-${var.env}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.videoeditvm_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
#    tags                = var.common_tags
# }

# ###################################################
# #                 VIRTUAL MACHINE                 #
# ###################################################
# resource "azurerm_windows_virtual_machine" "vm" {
#   count               = var.num_vid_edit_vms
#   name                = "${var.product}-videditvm${count.index}-${var.env}"
#   computer_name       = "PREVIDED0${count.index}-${var.env}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   size                = var.vid_edit_vm_spec
#   admin_username      = "videdit${count.index}_${random_string.vm_username[count.index].result}"
#   admin_password      = random_password.vm_password[count.index].result
#   network_interface_ids = [azurerm_network_interface.nic[count.index].id,]

#   os_disk {
#     name                 = "${var.product}-videditvm${count.index}-${var.env}-os-disk"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

  
#   source_image_reference {
#     publisher = "MicrosoftWindowsDesktop"
#     offer     = "Windows-10"
#     sku       = "20h1-pro-g2"
#     version   = "latest"
#   }
  
#   enable_automatic_updates = true
#   provision_vm_agent       = true  
#   tags                     = var.common_tags
# }


#------------------------------------------------------###################
# BASTION
#------------------------------------------------------###################
resource "azurerm_bastion_host" "bastion" {
  name                = "${var.product}-bastion-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "bastionpublic"
    subnet_id                     = azurerm_subnet.AzureBastionSubnet_subnet.id
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
  tags = var.common_tags
}
