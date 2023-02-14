vnet_address_space         = "10.48.1.0/24"   #"10.136.3.0/24"  #
video_edit_vm_snet_address = "10.48.1.0/28"   # /26 "10.136.3.0/28"  #
privatendpt_snet_address   = "10.48.1.64/26"  #"10.136.3.64/26"  # 
bastion_snet_address       = "10.48.1.128/26" #"10.136.3.128/26" #
data_gateway_snet_address  = "10.48.1.192/26" #"10.136.3.192/26" #
num_vid_edit_vms           = 1
mgmt_net_name              = "ss-ptlsbox-vnet"
mgmt_net_rg_name           = "ss-ptlsbox-network-rg"
mgmt_subscription_id       = "64b1c6d6-1481-44ad-b620-d8fe26a2c768"
env                        = "sbox"
power_app_user_oid         = "d055ba21-5814-4278-8752-aaffa7eaac62"
managed_oid                = "2008e85a-5f57-4a54-870e-abbacd6b4d09"
dts_pre_oid                = "b1fd4154-355f-4683-a795-d09cdb814d16"
dts_cft_developers_oid     = "b2a1773c-a5ae-48b5-b5fa-95b0e05eee05"
dts_pre_project_admin      = "56a29187-3d5f-4262-99d6-c635776e0eac"
dts_pre_app_admin          = "d055ba21-5814-4278-8752-aaffa7eaac62"
devops_admin               = "a0c6507c-299c-4f46-96c6-8275d2c45242"
pre_mi_principal_id        = "eb4aa503-5ffa-49ef-a69d-221e90eaf236"
pre_mi_tenant_id           = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
providernamespace          = "Microsoft.Compute"
featurename                = "EncryptionAtHost"
dts_pre_appreg_oid         = "e3fe0d7b-10a5-4e8a-9f31-863f8618b2f4"
dts_pre_ent_appreg_oid     = "c7ee0cd6-a440-49e9-8eb8-d050a49a5962"

pg_databases = [
  {
    name : "pre-pdb-sbox"
  }
]

retention_daily   = "0"
retention_weekly  = "0"
retention_monthly = "0"
retention_yearly  = "0"
