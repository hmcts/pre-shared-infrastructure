variable "product" {}

variable "location" {
  default = "UK South"
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

variable "mgmt_subscription_id" {}
variable "power_app_user_oid" {
  default = "56a29187-3d5f-4262-99d6-c635776e0eac"
}
