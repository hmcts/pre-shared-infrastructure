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
