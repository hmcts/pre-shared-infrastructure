terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.3.0"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 2.2.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_provider_registration" "EncryptionAtHost" {
  name = "Microsoft.Compute"
    feature {
    name       = "EncryptionAtHost"
    registered = true
  }
}

