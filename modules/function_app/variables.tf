variable "resource_group_name" {}

variable "name" {}

variable "location" {}

variable "app_settings" {
  type = map(string)
}

variable "os_type" {
  default = "Linux"
}

variable "product" {}

variable "common_tags" {}

variable "create_service_plan" {
  description = " If true a new service plan is created"
  default     = true
}

# variable "create_storage_account" {
#   description = " If true a new storage account is created"
#   default     = true
# }

variable "env" {}