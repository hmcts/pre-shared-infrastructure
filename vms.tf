##------------------------------------------------------###################
##BASTION
##------------------------------------------------------###################
resource "azurerm_public_ip" "pip" {
  name                = "${var.product}-bastionpip-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

##------------------------------------------------------###################
##BASTION
##------------------------------------------------------###################
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

###################################################
#            Editing NETWORK INTERFACE CARD               #
###################################################
resource "azurerm_network_interface" "nic" {
  count               = var.num_vid_edit_vms
  name                = "${var.product}-videditvmnic${count.index}-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.videoeditvm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
   tags                = var.common_tags
}

###################################################
#                 Editing VIRTUAL MACHINE                 #
###################################################
resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.num_vid_edit_vms
  name                = "${var.product}-videditvm${count.index}-${var.env}"
  computer_name       = "PREVIDED0${count.index}-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vid_edit_vm_spec
  admin_username      = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  admin_password      = random_password.vm_password[count.index].result
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    name                 = "${var.product}-videditvm${count.index}-osdisk-${var.env}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h1-pro-g2"
    version   = "latest"
  }
  
  enable_automatic_updates = true
  provision_vm_agent       = true  
  tags                     = var.common_tags
}




###################################################
#            Datagateway NETWORK INTERFACE CARD               #
###################################################
resource "azurerm_network_interface" "dtgwnic" {
  count               = var.num_datagateway
  name                = "${var.product}-dtgwnic${count.index}-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.datagateway_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
   tags                = var.common_tags
}

###################################################
#                DATAGATEWAY VIRTUAL MACHINE                 #
###################################################
resource "azurerm_windows_virtual_machine" "dtgtwyvm" {
  count               = var.num_datagateway
  zone                = 2
  name                = "${var.product}dtgtwy${count.index}-${var.env}"
  computer_name       = "PREDTGTW0${count.index}-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.datagateway_spec
  admin_username      = "Dtgtwy${count.index}_${random_string.dtgtwy_username[count.index].result}"
  admin_password      = random_password.dtgtwy_password[count.index].result
  network_interface_ids = [azurerm_network_interface.dtgwnic[count.index].id]

  os_disk {
    name                 = "${var.product}-dtgtwy${count.index}-osdisk-${var.env}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  identity {
    type = "SystemAssigned"
  }
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  enable_automatic_updates = true
  provision_vm_agent       = true  
  tags                     = var.common_tags
}

resource "azurerm_managed_disk" "datadisk" {
  count                = var.num_datagateway
  name                 = "${var.product}-dtgtwy${count.index}-datadisk-${var.env}"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
  zones                = [2]
  tags                 = var.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "dtgtwy" {
  count              = var.num_datagateway
  managed_disk_id    = azurerm_managed_disk.datadisk.*.id[count.index]
  virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
  lun                = "3"
  caching            = "ReadWrite"
}