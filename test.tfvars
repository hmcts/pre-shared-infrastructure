vnet_address_space         = "10.70.21.0/24"
video_edit_vm_snet_address = "10.70.21.0/26"
privatendpt_snet_address   = "10.70.21.64/26"
bastion_snet_address       = "10.70.21.128/26"
data_gateway_snet_address  = "10.70.21.192/26"
num_vid_edit_vms           = 2
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
mgmt_subscription_id       = "6c4d2513-a873-41b4-afdd-b05a33206631"
#env                         = "test"
# app_id                    = "a87b3880-6dce-4f9d-b4c4-c4cf3622cb5d"
# app_oid                   = "6df94cb5-c203-4493-bc8a-3f6aad1133e1"
power_app_user_oid     = "dbe1ceab-c6a0-4155-8f9c-060dbbbd5c2a"
managed_oid            = "2008e85a-5f57-4a54-870e-abbacd6b4d09" # 2008e85a-5f57-4a54-870e-abbacd6b4d09
dts_pre_oid            = "b1fd4154-355f-4683-a795-d09cdb814d16"
dts_cft_developers_oid = "b2a1773c-a5ae-48b5-b5fa-95b0e05eee05"
dts_pre_project_admin  = "56a29187-3d5f-4262-99d6-c635776e0eac"
dts_pre_app_admin      = "d055ba21-5814-4278-8752-aaffa7eaac62"
devops_admin           = "a0c6507c-299c-4f46-96c6-8275d2c45242"
pre_mi_principal_id    = "d03f73e6-40ed-40a2-a0ec-059286505905"
pre_mi_tenant_id       = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
dts_pre_appreg_oid     = "913743c8-60eb-4cca-a15c-2033db5118cd"
pg_databases = [
  {
    name : "pre-pdb-test"
  }
]
