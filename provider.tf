terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.84.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
}



# terraform {
#   required_providers {
#     random = {
#       source = "hashicorp/random"
#       version = "3.1.0"
#     }
#   }
# }

# provider "random" {
#   # Configuration options
# }

