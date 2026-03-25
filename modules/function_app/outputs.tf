output "function_app_name" {
  description = "Name of the Function App."
  value       = azurerm_linux_function_app.main.name
}

output "function_app_hostname" {
  description = "Default hostname of the Function App."
  value       = azurerm_linux_function_app.main.default_hostname
}

output "storage_account_name" {
  description = "Name of the Storage Account used by the Function App."
  value       = azurerm_storage_account.main.name
}

output "principal_id" {
  description = "Principal ID of the Function App's system-assigned managed identity."
  value       = azurerm_linux_function_app.main.identity[0].principal_id
}
