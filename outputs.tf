output "id" {
  value = try(azurerm_data_factory.factory[*].id, null)
}

output "identity" {
  value = try(azurerm_data_factory.factory[0].identity, null)
}