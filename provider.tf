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
    azapi = {
      source = "Azure/azapi"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.6"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.33.0"
    }
  }
}

provider "azapi" {
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }

  }
}

#COMMENTED OUT FOR TROUBLESHOOTING
# provider "azurerm" {
#   alias           = "oms"
#   subscription_id = module.log_analytics_workspace.subscription_id
#   features {}
# }

# provider "azurerm" {
#   tenant_id = data.azurerm_client_config.current.tenant_id
#   subscription_id            = local.hub[local.hub_name].subscription
#   skip_provider_registration = "true"
#   features {}
#   alias = "hub"
# }

provider "azuread" {
  tenant_id = data.azurerm_client_config.current.tenant_id
}
