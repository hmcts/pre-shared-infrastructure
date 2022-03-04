resource "azurerm_media_services_account" "ams" {
  name                = "${var.product}ams${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  storage_account {
    id         = module.ams_storage_account.storageaccount_id 
    is_primary = true
  }

  storage_account {
    id         = module.final_storage_account.storageaccount_id 
    is_primary = false
  }
  tags             = var.common_tags
}

#   key_delivery_access_control {
#     ip_allow_list = []
#     default_action = Deny
# }
#####TODO
# Modify the stroage account

