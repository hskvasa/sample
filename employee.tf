terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.89.0"
    }
  }
  #stores state file in azure storage account
  backend "azurerm" {
    resource_group_name = "emprg"
    container_name = "mysample"
    key = "my.emp.state"
  }
}

provider "azurerm" {
  features {
    
  }
}

# data is used to get existing resoures into code
data "azurerm_resource_group" "employeerg" {
  name = "emprg"
}

resource "azurerm_storage_account" "employeestorage" {
  name = "demoempstrg1"
  location = data.azurerm_resource_group.employeerg.location # existing resource can be referred like this
  resource_group_name = data.azurerm_resource_group.employeerg.name
  account_replication_type = "GRS"
  account_tier = "Standard"
  tags = {
    "owner" = "hemanth"
    "env" = "dev"
  }
} 

resource "azurerm_virtual_network" "vnet" {
  name = "empdemovnet1"
  resource_group_name = "emprg"
  location = azurerm_storage_account.employeestorage.location
  address_space = ["10.0.0.0/16"]
}

#Module 
module "dept" {
  source = "./dept" #this is should be folder always
  rgname = "deptrgdemo1"  # rgname rglocation and storagename are the varaibles supplied to dept moduel
  rglocation = "East US"
  storagename = "deptstoragedemo1"
}

