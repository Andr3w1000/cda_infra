# -------------------------------------------------------
# Function App
# -------------------------------------------------------

resource "azurerm_role_assignment" "function_app_eventhub_sender" {
  scope                = module.event_hub.namespace_id
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = module.function_app.principal_id
}

# -------------------------------------------------------
# Databricks Service Principal
# -------------------------------------------------------

resource "azurerm_role_assignment" "databricks_sp_eventhub_receiver" {
  scope                = module.event_hub.namespace_id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = module.databricks_sp.object_id
}

resource "azurerm_role_assignment" "databricks_sp_contributor" {
  scope                = module.databricks.id
  role_definition_name = "Contributor"
  principal_id         = module.databricks_sp.object_id
}

# -------------------------------------------------------
# Owner (interactive development)
# -------------------------------------------------------

resource "azurerm_role_assignment" "owner_eventhub_receiver" {
  scope                = module.event_hub.namespace_id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = var.owner_object_id
}

resource "azurerm_role_assignment" "owner_eventhub_sender" {
  scope                = module.event_hub.namespace_id
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = var.owner_object_id
}
