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

#Key Vault
module "vault" {
  depends_on = [module.resource_group, module.vnet]
  source     = "clouddrove/key-vault/azure"
  version    = "1.0.3"

  name        = "annkkdsovvdcc"
  environment = "test1"
  label_order = ["name", "environment", ]

  resource_group_name = module.resource_group.resource_group_name

  purge_protection_enabled    = false
  enabled_for_disk_encryption = true

  sku_name = "standard"

  subnet_id          = module.vnet.vnet_subnets[0]
  virtual_network_id = module.vnet.vnet_id[0]
  #private endpoint
  enable_private_endpoint       = true
  public_network_access_enabled = true

  #access_policy
  access_policy = [
    {
      object_id = "71d1a02f-3ae9-4ab9-8fec-d9b1166d7c97"
      key_permissions = [
        "Get",
        "List",
        "Update",
        "Create",
        "Import",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "UnwrapKey",
        "WrapKey",
        "GetRotationPolicy"
      ]
      certificate_permissions = [
        "Get",
        "List",
        "Update",
        "Create",
        "Import",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "ManageContacts",
        "ManageIssuers",
        "GetIssuers",
        "ListIssuers",
        "SetIssuers",
        "DeleteIssuers"
      ]
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Recover",
        "Backup",
        "Restore"
      ]
      storage_permissions = []

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
  identity_type          = "SystemAssigned"
  cmk_encryption_enabled = true
  key_vault_id           = module.vault.id

  # Private Endpoint
  enable_private_endpoint = true
  # virtual_network_id = module.vnet.vnet_id
  subnet_id = module.vnet.vnet_subnets[0]
}