variable "product" {
  default = "pre"
}
variable "location" {
  default = "UK South"
}

variable "subscription" {
  default = ""
}
variable "env" {}

variable "jenkins_AAD_objectId" {}


variable "common_tags" {
  type = map(string)
}

variable "sa_account_tier" {
  default = "Standard"
}

variable "sa_replication_type" {
  default = "LRS"
}

variable "vnet_address_space" {}

variable "video_edit_vm_snet_address" {}

variable "privatendpt_snet_address" {}

variable "bastion_snet_address" {}

variable "data_gateway_snet_address" {}

variable "mgmt_net_name" {}

variable "mgmt_net_rg_name" {}

variable "num_vid_edit_vms" {
  default = 1
}
variable "vid_edit_vm_spec" {
  default = "Standard_E2s_v4"
}
variable "num_datagateway" {
  default = 2
}
variable "datagateway_spec" {
  default = "Standard_F8s_v2"
}

variable "mgmt_subscription_id" {}
variable "power_app_user_oid" {
  default = "56a29187-3d5f-4262-99d6-c635776e0eac"
}
variable "jenkins_ptlsbox_oid" {
  default = "6df94cb5-c203-4493-bc8a-3f6aad1133e1"
}
variable "jenkins_ptlsbox_appid" {
  default = "a87b3880-6dce-4f9d-b4c4-c4cf3622cb5d"
}
variable "managed_oid" {}
variable "dts_pre_oid" {}
variable "dts_cft_developers_oid" {}
variable "dts_pre_project_admin" {}

variable "ip_rules" {
  type        = list(string)
  description = "PowerPlatformInfra.UKSouth - List of public IP addresses which will have access to storage account."
  default     = ["20.49.145.249/32"]
}

variable "allow_blob_public_access" {
  description = "(Optional) Allow or disallow public access to all blobs or containers in the storage account. Defaults to false."
  default     = "false"
}
variable "powerplatform_uksouth" {
  description = "PowerPlatformInfra.UKSouth"
  type        = list(string)
  default     = [
"20.49.145.249/32",
"20.49.166.40/32",
"20.49.166.118/32",
"20.49.166.129/32",
"20.49.244.238/32",
"20.90.131.0/26",
"20.90.131.64/27",
"20.90.131.120/29",
"20.90.169.112/32",
"20.108.81.107/32",
"51.11.24.198/32",
"51.11.25.68/32",
"51.11.25.172/32",
"51.11.172.30/32",
"51.11.172.56/32",
"51.11.172.160/32",
"51.104.30.172/30",
"51.104.30.192/26",
"51.104.31.0/27",
"51.104.31.32/28",
"51.104.31.48/29",
"51.104.31.64/26",
"51.104.248.11/32",
"51.132.161.225/32",
"51.132.215.162/32",
"51.132.215.182/32",
"51.143.208.216/29",
"51.145.104.29/32"
]
}