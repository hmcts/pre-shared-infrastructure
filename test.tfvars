#network
vnet_address_space         = "10.70.21.0/24"
video_edit_vm_snet_address = "10.70.21.0/26"
privatendpt_snet_address   = "10.70.21.64/26"
bastion_snet_address       = "10.70.21.128/26"
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
mgmt_subscription_id       = "6c4d2513-a873-41b4-afdd-b05a33206631"

#identities
dts_pre_ent_appreg_oid    = "fd9eddbb-3ec9-4fda-81fc-d518d4718a70"
pre_ent_appreg_app_id     = "66930c25-cbaa-4b9b-81ab-bea600666acb"
dts_pre_backup_appreg_oid = "7716f08a-c384-4113-bf26-05a04a1f909b"

#backups
retention_duration         = "P7D"
immutability_period_backup = "7"
restore_policy_days        = "1"

#  storage lifecycle management enabled
delete_after_days_since_creation_greater_than = 90
storage_policy_enabled                        = true

#vms
num_vid_edit_vms   = 0
tenant_id          = "yrk32651"
edit_vm_private_ip = ["10.70.21.6", "10.70.21.7"]

edit_vm_data_disks = [{
  datadisk1 = {
    name                 = "edit-vm01-data-test"
    location             = "uksouth"
    resource_group_name  = "pre-test"
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
      name                 = "edit-vm02-data-test"
      location             = "uksouth"
      resource_group_name  = "pre-test"
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

apim_service_url = "https://pre-api.test.platform.hmcts.net"

pre_apim_b2c_app_object_id = "1694b693-8e90-4adc-a48d-0298e2e90b0b"

b2c_tenant_id = "44379efc-6244-4e94-ab4d-aad9b6778220"