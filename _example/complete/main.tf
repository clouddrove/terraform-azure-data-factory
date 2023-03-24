provider "azurerm" {
  features {}
}

## Resource Group
module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.0"
  label_order = ["name", "environment", ]
  name        = "datafactory"
  environment = "test"
  location    = "North Europe"
}

#Vnet
module "vnet" {
  source  = "clouddrove/virtual-network/azure"
  version = "1.0.3"

  name        = "app"
  environment = "example"
  label_order = ["name", "environment"]

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/16"
  enable_ddos_pp      = false

  #subnet
  subnet_names                  = ["subnet1"]
  subnet_prefixes               = ["10.0.1.0/24"]
  disable_bgp_route_propagation = false

  # routes
  enabled_route_table = false
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
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

  #identity
  # identity_type          = "SystemAssigned"
  # cmk_encryption_enabled = false
  # key_vault_id           = module.vault.id

  # # Private Endpoint
  # enable_private_endpoint = false
  # # virtual_network_id = module.vnet.vnet_id
  # subnet_id = module.vnet.vnet_subnets[0]
}