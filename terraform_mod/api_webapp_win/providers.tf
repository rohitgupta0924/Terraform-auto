terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.9.0"
    }
  }
}

provider "azapi" {
  environment                = "public"
  use_msi                    = false
  use_cli                    = true
  use_oidc                   = false
  skip_provider_registration = true
}