variable "product" {
  default = "pre-recorded-evidence"
}

variable "prefix" {
  default = "pre"
}

variable "location" {
  default = "UK South"
}

variable "subscription" {
  default = ""
}

variable "env" {}

variable "dts_pre_ent_appreg_oid" {}

variable "builtFrom" {
  description = "The GitHub URL for the repository that contains the infrastructure code."
  default     = "hmcts/pre-shared-infrastructure"
}

variable "num_vid_edit_vms" {
  default = 2
}

variable "num_datagateway" {
  default = 2
}

variable "vid_edit_vm_spec" {
  default = "Standard_E4s_v4"
}

variable "datagateway_spec" {
  default = "Standard_F8s_v2"
}

variable "server" {
  default = null
}

variable "hostgroup" {
  default = null
}

variable "PrivateDNSZone" {
  default = "private.postgres.database.azure.com"
}

variable "DNSResGroup" {
  default = "core-infra-intsvc-rg"
}

variable "dts_pre_app_admin" {}
