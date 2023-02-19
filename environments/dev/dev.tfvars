vnet_address_space         = "10.40.12.0/26"
video_edit_vm_snet_address = "10.40.12.0/28"
data_gateway_snet_address  = "10.40.12.16/28"
privatendpt_snet_address   = "10.40.12.32/28"
bastion_snet_address       = "10.40.12.48/28"
num_vid_edit_vms           = 1
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
env                        = "dev"
#managed_oid                = "2008e85a-5f57-4a54-870e-abbacd6b4d09" #most envs using pre-stg-mi. tbd: use the right ones
dts_cft_developers_oid = "b2a1773c-a5ae-48b5-b5fa-95b0e05eee05" #giving cft-developers additional access to our vault for some reason
# dts_pre_project_admin      = "56a29187-3d5f-4262-99d6-c635776e0eac" #this id doesn't even show up in AD
#pre_mi_principal_id        = "d03f73e6-40ed-40a2-a0ec-059286505905" #they're all declaring pre-demo-mi but doesn't look like it's being called anywhere
#pre_mi_tenant_id           = "531ff96d-0ae9-462a-8d2d-bec7c0b42082" #likely useless
#dts_pre_app_admin          = "d055ba21-5814-4278-8752-aaffa7eaac62" #DTS-PRE-App-Sbx Admin can't see this called anywhere

# dts_pre_appreg_oid     = "b521e9e3-58e1-4c25-98b5-7f3157f68c16" # dts_pre_devapp reg
dts_pre_ent_appreg_oid = "9168b884-7ccd-4e71-860f-7f63455818e1" # dts_pre_dev enterprise app/sp
# dts_pre_oid            = "b1fd4154-355f-4683-a795-d09cdb814d16" # DTS Pre-recorded Evidence / 
# mgmt_subscription_id       = "6c4d2513-a873-41b4-afdd-b05a33206631"
PeeringFromHubName     = "pre-recorded-evidence-dev"
pg_databases = [
  {
    name : "pre-pdb-dev"
  }
]