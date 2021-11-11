variable "product" {}

variable "location" {
  default = "UK South"
}

variable "env" {}
variable "jenkins_AAD_objectId" {}

variable "common_tags" {
  type = map(string)
}
