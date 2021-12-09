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

variable "snet01_address_prefix" {}

variable "snet02_address_prefix" {}

variable "num_vid_edit_vms" {
  default = 1
}
variable "vid_edit_vm_spec" {
  default = "Standard_E4s_v3"
}
variable "mgmt_subscription_id" {}
