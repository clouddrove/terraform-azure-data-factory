provider "azurerm" {
  features {}
}

## Resource Group
module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.2"
  name        = "app"
  environment = "test"
  label_order = ["name", "environment", ]
  location    = "North Europe"
}

module "vnet" {
  source              = "clouddrove/vnet/azure"
  version             = "1.0.4"
  name                = "app"
  environment         = "test"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

module "subnet" {
  source               = "clouddrove/subnet/azure"
  version              = "1.1.0"
  name                 = "app"
  environment          = "test"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name

  #subnet
  subnet_names    = ["subnet1"]
  subnet_prefixes = ["10.0.1.0/24"]

  # route_table
  enable_route_table = false
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

module "data_factory" {
  version = "3.92.0"
  depends_on = [
    module.resource_group
  ]
  source = "clouddrove/data-factory/azure"

  name                = "app"
  environment         = "test"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  public_network_enabled = false

  #identity
  # identity_type          = "SystemAssigned"
  # cmk_encryption_enabled = false
  # key_vault_id           = module.vault.id

  # # Private Endpoint
  # enable_private_endpoint = false
  # # virtual_network_id = module.vnet.vnet_id
  # subnet_id = module.subnet.default_subnet_id[0]
}

