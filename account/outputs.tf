output "metastore_id" {
  description = "ID of the Unity Catalog metastore. Pass as metastore_id in each workspace root."
  value       = databricks_metastore.this.id
}

output "external_location_url" {
  description = "URL of the metastore root external location."
  value       = databricks_external_location.metastore_root.url
}

output "access_connector_id" {
  description = "Resource ID of the Databricks Access Connector."
  value       = azurerm_databricks_access_connector.this.id
}
