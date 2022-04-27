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
  description = "PowerPlatformInfra.UKSouth"
  type        = list(string)
  default     = [
                "20.49.145.249/30",
                "20.49.166.40/30",
                "20.49.166.118/30",
                "20.49.166.129/30",
                "20.49.244.238/30",
                "20.58.70.192/27",
                "20.58.70.224/28", 
                "20.90.125.211", 
                "20.90.124.134",
                "20.90.129.0/27",
                "20.90.129.32/28",
                "20.90.131.0/26",
                "20.90.131.64/27",
                "20.90.131.120/29",
                "20.90.169.112/30",
                "20.108.81.107/30",
                "51.11.24.198/30",
                "51.11.25.68/30",
                "51.11.25.172/30",
                "51.11.172.30/30",
                "51.11.172.56/30",
                "51.11.172.160/30",
                "51.104.30.172/30",
                "51.104.30.192/26",
                "51.104.31.0/27",
                "51.104.31.32/28",
                "51.104.31.48/29",
                "51.104.31.64/26",
                "51.104.248.11/30",
                "51.132.161.225/30",
                "51.132.215.162/30",
                "51.132.215.182/30",
                "51.143.208.216/29",
                "51.145.104.29/30",
                "51.140.77.227", 
                "51.140.245.29", 
                "51.140.80.51", 
                "51.140.61.124", 
                "51.141.47.105", 
                "51.141.124.13", 
                "51.105.77.96/27",
                "51.140.148.0/28",
                "51.140.211.0/28",
                "51.140.212.224/27",
                ]
}