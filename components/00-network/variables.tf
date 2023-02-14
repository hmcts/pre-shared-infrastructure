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

variable "builtFrom" {
  description = "The GitHub URL for the repository that contains the infrastructure code."
  default     = "hmcts/pre-shared-infrastructure"
}