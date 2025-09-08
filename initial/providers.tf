terraform {
  #required_version = ">=1.0, <=1.8.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  resource_provider_registrations = "core"
  subscription_id                 = "5a24dfcd-770d-4c34-b320-1a4b42ca46bc"
}