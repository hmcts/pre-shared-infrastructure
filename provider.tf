provider "azurerm" {
  version = "=2.26.0"
  features {}
}

terraform {
  backend "azurerm" {}
}
