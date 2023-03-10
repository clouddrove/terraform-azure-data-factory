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
}