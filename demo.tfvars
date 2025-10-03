#network
vnet_address_space         = "10.50.12.0/24"
video_edit_vm_snet_address = "10.50.12.0/26"
privatendpt_snet_address   = "10.50.12.64/26"
bastion_snet_address       = "10.50.12.128/26"
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
mgmt_subscription_id       = "6c4d2513-a873-41b4-afdd-b05a33206631"

#identites
dts_pre_ent_appreg_oid    = "863c5fa3-df86-4ebc-8b0f-cd2390028497"
pre_ent_appreg_app_id     = "14f8f054-8511-45ea-91fe-663daf87ec40"
dts_pre_backup_appreg_oid = "7716f08a-c384-4113-bf26-05a04a1f909b"

#backups
retention_duration         = "P1D"
immutability_period_backup = "1"
restore_policy_days        = "1"

#vms
tenant_id          = "yrk32651"
edit_vm_private_ip = ["10.50.12.6", "10.50.12.7"]

edit_vm_data_disks = [{
  datadisk1 = {
    name                 = "edit-vm01-data-demo"
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
      name                 = "edit-vm02-data-demo"
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

# Dynatrace
cnp_vault_sub = "1c4f0704-a29e-403d-b719-b90c34ef14c9"

apim_service_url = "https://pre-api.demo.platform.hmcts.net"

pre_apim_b2c_app_object_id = "5a94e6c8-2b60-4a3e-adf7-c79ed6f5c7f4"