# Grant the Access Connector's managed identity read/write access to the metastore storage.
resource "azurerm_role_assignment" "access_connector_storage" {
  scope                = azurerm_storage_account.metastore.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id
}
