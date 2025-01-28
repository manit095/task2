terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.5.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id = "<Your client id>"
  client_secret = "<Your secret key>"
  tenant_id = "<Your tenet id>"
  subscription_id = "<Your subcription id>"
}
