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
provider "azurerm" {
  alias           = "oms"
  subscription_id = module.log_analytics_workspace.subscription_id
  features {}
}

data "azuread_service_principal" "kv" {
  # display_name = "Azure Key Vault"
  application_id = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"
}



