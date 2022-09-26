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
  skip_provider_registration = true
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

provider "azurerm" {
  alias                      = "cnp"
  skip_provider_registration = "true"
  features {}
  subscription_id = var.cnp_vault_sub
}

data "azuread_service_principal" "kv" {
  # display_name = "Azure Key Vault"
  application_id = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"
}


data "azurerm_key_vault" "cnp_vault" {
  provider            = azurerm.cnp
  name                = "infra-vault-${local.dynatrace_env}"
  resource_group_name = var.cnp_vault_rg
}

data "azurerm_key_vault_secret" "token" {
  provider = azurerm.cnp

  name         = "dynatrace-${local.dynatrace_env}-token"
  key_vault_id = data.azurerm_key_vault.cnp_vault.id
}
# resource "null_resource" "PowerShellScriptRunFirstTimeOnly" {
#     provisioner "local-exec" {
#         command = "Register-AzProviderFeature -FeatureName "EncryptionAtHost" -ProviderNamespace "Microsoft.Compute" "
#         interpreter = ["PowerShell", "-Command"]
#     }
# }
# resource "azurerm_resource_provider_registration" "EncryptionAtHost" {
#   name = "Microsoft.Compute/EncryptionAtHost"
#   #   feature {
#   #   name       = "EncryptionAtHost"
#   #   registered = true
#   # }
# }

# azurerm_storage_account_customer_managed_key

