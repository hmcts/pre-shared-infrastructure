variable "product" {
  default = "pre-recorded-evidence"
}

variable "prefix" {
  default = "pre"
}

variable "location" {
  default = "UK South"
}

variable "env" {}

variable "hostgroup" {
  default = null
}

variable "PrivateDNSZone" {
  default = "private.postgres.database.azure.com"
}

variable "DNSResGroup" {
  default = "core-infra-intsvc-rg"
}

variable "vnet_address_space" {}

variable "video_edit_vm_snet_address" {}

variable "privatendpt_snet_address" {}

variable "bastion_snet_address" {}

variable "data_gateway_snet_address" {}

variable "mgmt_subscription_id" {
  default = "6c4d2513-a873-41b4-afdd-b05a33206631"
}

variable "mgmt_net_name" {
  default = "ss-ptl-vnet"
}

variable "mgmt_net_rg_name" {
  default = "ss-ptl-network-rg"
}

variable "builtFrom" {
  description = "The GitHub URL for the repository that contains the infrastructure code."
  default     = "hmcts/pre-shared-infrastructure"
}
