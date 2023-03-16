variable "resource_group_name" {}

variable "name" {}

variable "location" {}

variable "app_settings" {
  type    = map(string)
}

variable "storage_account_name" {}

variable "storage_account_key" {}

variable "os_type" {
  default = "Linux"
}

variable "product" {}

variable "worker_count" {}
