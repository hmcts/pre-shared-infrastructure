variable "product" {}

variable "location" {
  default = "UK South"
}

variable "env" {}

variable "common_tags" {
  type = map(string)
}
