output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.main.name
}

output "function_app_name" {
  description = "Name of the Function App."
  value       = module.function_app.function_app_name
}

output "function_app_hostname" {
  description = "Default hostname of the Function App."
  value       = module.function_app.function_app_hostname
}

output "storage_account_name" {
  description = "Name of the Storage Account used by the Function App."
  value       = module.function_app.storage_account_name
}

output "eventhub_namespace_name" {
  description = "Name of the Event Hub Namespace."
  value       = module.event_hub.namespace_name
}

output "eventhub_name" {
  description = "Name of the Event Hub."
  value       = module.event_hub.eventhub_name
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault."
  value       = module.key_vault.uri
}

output "databricks_workspace_url" {
  description = "URL of the Databricks workspace."
  value       = module.databricks.workspace_url
}

output "databricks_sp_client_id" {
  description = "Client ID of the Databricks service principal."
  value       = azuread_application.databricks_jobs.client_id
}
