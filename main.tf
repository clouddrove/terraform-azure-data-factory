## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

#Module      : labels
#Description : Terraform module to create consistent naming for multiple names.
module "labels" {
  source      = "clouddrove/labels/azure"
  version     = "1.0.0"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

# Random String
resource "random_string" "random" {
  length  = 5
  special = false
  numeric = true

  keepers = {
    domain_name_label = var.name
  }
}

resource "azurerm_data_factory" "factory" {
  count               = var.enabled ? 1 : 0
  name                = format("%s-data-factory-%s", module.labels.id, random_string.random.result)
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = module.labels.tags

  lifecycle {
    ignore_changes = [
      vsts_configuration,
      github_configuration,
      global_parameter
    ]
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? [join("", azurerm_user_assigned_identity.identity.*.id)] : null
    }
  }
}

resource "azurerm_user_assigned_identity" "identity" {
  count               = var.cmk_encryption_enabled ? 1 : 0
  location            = var.location
  name                = format("midd-adf-%s", module.labels.id)
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "identity_assigned" {
  depends_on           = [azurerm_user_assigned_identity.identity]
  count                = var.cmk_encryption_enabled ? 1 : 0
  principal_id         = join("", azurerm_user_assigned_identity.identity.*.principal_id)
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
}

resource "azurerm_key_vault_key" "kvkey" {
  count        = var.cmk_encryption_enabled ? 1 : 0
  name         = format("cmk-%s", module.labels.id)
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

# Private Endpoint

resource "azurerm_private_endpoint" "pep" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = format("%s-pe-adf", module.labels.id)
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = var.subnet_id
  tags                = module.labels.tags
  private_service_connection {
    name                           = format("%s-psc-adf", module.labels.id)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_data_factory.factory[0].id
    subresource_names              = ["dataFactory"]
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

locals {
  resource_group_name   = var.resource_group_name
  location              = var.location
  valid_rg_name         = var.existing_private_dns_zone == null ? local.resource_group_name : var.existing_private_dns_zone_resource_group_name
  private_dns_zone_name = var.existing_private_dns_zone == null ? azurerm_private_dns_zone.dnszone[0].name : var.existing_private_dns_zone
}

data "azurerm_private_endpoint_connection" "private-ip-0" {
  count               = var.enable_private_endpoint && var.cmk_encryption_enabled ? 1 : 0
  name                = join("", azurerm_private_endpoint.pep.*.name)
  resource_group_name = local.resource_group_name
  depends_on          = [azurerm_data_factory.factory]
}

resource "azurerm_private_dns_zone" "dnszone" {
  count               = var.existing_private_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.resource_group_name
  tags                = module.labels.tags
}

# resource "azurerm_private_dns_zone_virtual_network_link" "addon_vent_link" {
#   count                 = var.enabled && var.addon_vent_link ? 1 : 0
#   name                  = format("%s-pdz-vnet-link-adf-addon", module.labels.id)
#   resource_group_name   = var.addon_resource_group_name
#   private_dns_zone_name = var.existing_private_dns_zone == null ? join("", azurerm_private_dns_zone.dnszone.*.name) : var.existing_private_dns_zone
#   virtual_network_id    = var.addon_virtual_network_id
#   tags                  = module.labels.tags
# }

resource "azurerm_private_dns_a_record" "arecord" {
  count               = var.enable_private_endpoint == false ? 1 : 0
  name                = azurerm_data_factory.factory.*.name
  zone_name           = local.private_dns_zone_name
  resource_group_name = local.valid_rg_name
  ttl                 = 3600
  records             = [data.azurerm_private_endpoint_connection.private-ip-0.0.private_service_connection.0.private_ip_address]
  tags                = module.labels.tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}