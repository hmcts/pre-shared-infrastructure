#network
env                        = "demo"
vnet_address_space         = "10.50.12.0/24"
video_edit_vm_snet_address = "10.50.12.0/26"
privatendpt_snet_address   = "10.50.12.64/26"
bastion_snet_address       = "10.50.12.128/26"
data_gateway_snet_address  = "10.50.12.192/26"
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
mgmt_subscription_id       = "6c4d2513-a873-41b4-afdd-b05a33206631"

#identites
pre_app_admin             = "f6991ff8-d675-4f54-b2ba-99af86a8e01c"
dts_pre_appreg_oid        = "d47c3c69-6bec-4725-ac2d-45d2c21cbd7b"
dts_pre_ent_appreg_oid    = "863c5fa3-df86-4ebc-8b0f-cd2390028497"
pre_ent_appreg_app_id     = "14f8f054-8511-45ea-91fe-663daf87ec40"
pre_mi_principal_id       = "d03f73e6-40ed-40a2-a0ec-059286505905" #pre-demo-mi
dts_pre_backup_appreg_oid = "7716f08a-c384-4113-bf26-05a04a1f909b"

#backups
retention_duration         = "P1D"
immutability_period_backup = "1"

#vms
num_vid_edit_vms         = 1
tenant_id                = "yrk32651"
dg_vm_private_ip         = ["10.40.12.22", "10.40.12.23"]
powerbi_dg_vm_private_ip = ["10.40.12.24", "10.40.12.25"]
edit_vm_private_ip       = ["10.40.12.6", "10.40.12.7"]
dg_vm_data_disks = [{
  datadisk1 = {
    name                 = "data-gateway-vm01-data-demo"
    location             = "uksouth"
    resource_group_name  = "pre-demo"
    storage_account_type = "StandardSSD_LRS"
    disk_create_option   = "Empty"
    disk_size_gb         = "1000"
    disk_tier            = null
    disk_zone            = "1"
    source_resource_id   = null
    storage_account_id   = null
    hyper_v_generation   = null
    os_type              = null


    disk_lun                 = "10"
    attachment_create_option = "Attach"
    disk_caching             = "ReadWrite"

  }
  },
  {
    datadisk1 = {
      name                 = "data-gateway-vm02-data-demo"
      location             = "uksouth"
      resource_group_name  = "pre-demo"
      storage_account_type = "StandardSSD_LRS"
      disk_create_option   = "Empty"
      disk_size_gb         = "1000"
      disk_tier            = null
      disk_zone            = "2"
      source_resource_id   = null
      storage_account_id   = null
      hyper_v_generation   = null
      os_type              = null


      disk_lun                 = "10"
      attachment_create_option = "Attach"
      disk_caching             = "ReadWrite"

    }
}]
powerbi_dg_vm_data_disks = [{
  datadisk1 = {
    name                     = "powerbi-dg1-data-demo"
    location                 = "uksouth"
    resource_group_name      = "pre-demo"
    storage_account_type     = "StandardSSD_LRS"
    disk_create_option       = "Empty"
    disk_size_gb             = "1000"
    disk_tier                = null
    disk_zone                = "1"
    source_resource_id       = null
    storage_account_id       = null
    hyper_v_generation       = null
    os_type                  = null
    disk_lun                 = "10"
    attachment_create_option = "Attach"
    disk_caching             = "ReadWrite"
  }
  },
  {
    datadisk1 = {
      name                     = "powerbi-dg2-data-demo"
      location                 = "uksouth"
      resource_group_name      = "pre-demo"
      storage_account_type     = "StandardSSD_LRS"
      disk_create_option       = "Empty"
      disk_size_gb             = "1000"
      disk_tier                = null
      disk_zone                = "2"
      source_resource_id       = null
      storage_account_id       = null
      hyper_v_generation       = null
      os_type                  = null
      disk_lun                 = "10"
      attachment_create_option = "Attach"
      disk_caching             = "ReadWrite"
    }
}]