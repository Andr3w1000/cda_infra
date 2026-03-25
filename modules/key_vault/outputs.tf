output "id" {
  description = "Resource ID of the Key Vault."
  value       = azurerm_key_vault.main.id
}

output "name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.main.name
}

output "uri" {
  description = "URI of the Key Vault (e.g. https://<name>.vault.azure.net/)."
  value       = azurerm_key_vault.main.vault_uri
}
