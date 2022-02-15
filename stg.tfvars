vnet_address_space    = "10.101.0.0/24"
snet01_address_prefix = "10.101.0.0/26" #pre-video-edit-vm-stg
snet02_address_prefix = "10.101.0.64/26" #pre-privatelink-vm-stg
snet03_address_prefix = "10.101.0.128/26" #pre-bastion-stg
snet04_address_prefix = "10.101.0.192/26" #pre-data-gateway-stg
num_vid_edit_vms      = 1
mgmt_net_name         = "ss-ptl-vnet"
mgmt_net_rg_name      = "ss-ptl-network-rg"