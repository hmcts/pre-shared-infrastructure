terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.33.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }

  }
}

provider "azurerm" {
  alias           = "oms"
  subscription_id = module.log_analytics_workspace.subscription_id
  features {}
}

# provider "azuread" {
#   tenant_id = data.azurerm_client_config.current.tenant_id
# }