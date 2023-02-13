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

variable "num_vid_edit_vms" {
  default = 2
}

variable "vid_edit_vm_spec" {
  default = "Standard_E4s_v4"
}

variable "num_datagateway" {
  default = 2
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

