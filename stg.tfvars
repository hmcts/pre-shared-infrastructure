#network
vnet_address_space         = "10.101.0.0/24"
video_edit_vm_snet_address = "10.101.0.0/26"
privatendpt_snet_address   = "10.101.0.64/26"
bastion_snet_address       = "10.101.0.128/26"
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
mgmt_subscription_id       = "6c4d2513-a873-41b4-afdd-b05a33206631"

#identities
dts_pre_ent_appreg_oid    = "0f7b27ab-60b6-4682-8491-8e4eb5498dad"
pre_ent_appreg_app_id     = "2f4bf1fd-543c-4332-bc26-7a524f52d375"
dts_pre_backup_appreg_oid = "8cb76e1e-ef5a-41a7-9cb4-9513a48535dc"

#backups
retention_duration         = "P1D"
immutability_period_backup = "1"
restore_policy_days        = "1"

#  storage lifecycle management enabled
delete_after_days_since_creation_greater_than = 90
storage_policy_enabled                        = true

#vms
tenant_id          = "yrk32651"
edit_vm_private_ip = ["10.101.0.6", "10.101.0.7"]

edit_vm_data_disks = [{
  datadisk1 = {
    name                 = "edit-vm01-data-stg"
    location             = "uksouth"
    resource_group_name  = "pre-stg"
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
      name                 = "edit-vm02-data-stg"
      location             = "uksouth"
      resource_group_name  = "pre-stg"
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

apim_service_url = "https://pre-api.staging.platform.hmcts.net"

pre_apim_b2c_app_object_id = "3f7577fd-5329-4265-bd5b-01ee5717113d"

b2c_tenant_id = "8b185f8b-665d-4bb3-af4a-ab7ee61b9334"