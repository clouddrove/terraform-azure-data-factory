output "id" {
  value = join("", azurerm_data_factory.factory.*.id)
}

output "identity" {
  value = azurerm_data_factory.factory[0].identity
}