# Create storage account
resource "azurerm_storage_account" "storage" {
  name = "terraformstate${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

# Create container in storage account
resource "azurerm_storage_container" "container" {
  name = "tfstate"
  storage_account_name = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "random_string" "suffix" {
  length = 6
  special = false
  upper = false
}

# Terraform backend configuration
terraform {
  backend "azurerm" {
    resource_group_name = "azurerm_resource_group.rg.name"
    storage_account_name = "azurerm_storage_account.storage.name"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}
