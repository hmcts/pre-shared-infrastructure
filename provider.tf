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

