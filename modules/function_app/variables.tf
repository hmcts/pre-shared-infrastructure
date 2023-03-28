variable "resource_group_name" {}

variable "name" {}

variable "location" {}

variable "app_settings" {
  type = map(string)
}

variable "storage_account_name" {}

variable "storage_account_key" {}

variable "os_type" {
  default = "Linux"
}

variable "product" {}

variable "worker_count" {}

variable "common_tags" {}

variable "create_service_plan" {
  description = " If true a new service plan is created"
  default     = true
}

variable "env" {}