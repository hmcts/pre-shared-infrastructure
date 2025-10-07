#network
vnet_address_space         = "10.101.3.0/24"
video_edit_vm_snet_address = "10.101.3.0/26"
privatendpt_snet_address   = "10.101.3.64/26"
bastion_snet_address       = "10.101.3.128/26"
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
mgmt_subscription_id       = "6c4d2513-a873-41b4-afdd-b05a33206631"

#identities
dts_pre_ent_appreg_oid    = "bec31833-3791-4d2a-80cc-871f5582f128"
pre_ent_appreg_app_id     = "a4e4402d-25a8-40aa-ba12-ad040350086e"
dts_pre_backup_appreg_oid = "8cb76e1e-ef5a-41a7-9cb4-9513a48535dc"

#backups
retention_duration         = "P100D"
immutability_period_backup = "2557"
restore_policy_days        = "100"

#vms
tenant_id          = "ebe20728"
edit_vm_private_ip = ["10.101.3.6", "10.101.3.7"]

edit_vm_data_disks = [{
  datadisk1 = {
    name                 = "edit-vm01-data-prod"
    location             = "uksouth"
    resource_group_name  = "pre-prod"
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
      name                 = "edit-vm02-data-prod"
      location             = "uksouth"
      resource_group_name  = "pre-prod"
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
cnp_vault_sub = "8999dec3-0104-4a27-94ee-6588559729d1"

apim_service_url = "https://pre-api.platform.hmcts.net"

num_adf = 1

edit_vm_force_run_id = "20251007"

pre_apim_b2c_app_object_id = "8879f7d3-edf7-4452-a51b-33770bc29c8d"
