provider "azurerm" {
  features {}
}

## Resource Group
module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.0"
  label_order = ["name", "environment", ]
  name        = "app"
  environment = "test"
  location    = "North Europe"
}

module "data_factory" {
  depends_on = [
    module.resource_group
  ]
  source = "../../"

  name                = "app"
  environment         = "test"
  label_order         = ["name", "environment"]
  enabled             = true
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
}