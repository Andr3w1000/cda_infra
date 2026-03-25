output "id" {
  description = "Resource ID of the Databricks workspace."
  value       = azurerm_databricks_workspace.main.id
}

output "workspace_url" {
  description = "URL of the Databricks workspace (e.g. https://adb-<id>.azuredatabricks.net)."
  value       = azurerm_databricks_workspace.main.workspace_url
}

output "workspace_id" {
  description = "Unique numeric ID of the Databricks workspace."
  value       = azurerm_databricks_workspace.main.workspace_id
}
