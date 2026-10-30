
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
 
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-azure-migration-dev"
  location = "Central India"

  tags = {
    Environment = "Dev"
    Project     = "AWS-to-Azure-Migration"
  }
}

# 2. Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-azure-migration-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.10.0.0/16"]
}

# 3. Application Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-app-dev"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

# 4. Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "stazmigdev12345"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = false

  tags = {
    Environment = "Dev"
    Purpose     = "TerraformState"
  }
}

# 5. Blob Container
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

# 6. Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "law-azure-migration-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = "Dev"
  }
}