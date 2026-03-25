output "namespace_name" {
  description = "Name of the Event Hub Namespace."
  value       = azurerm_eventhub_namespace.main.name
}

output "eventhub_name" {
  description = "Name of the Event Hub."
  value       = azurerm_eventhub.main.name
}

output "namespace_id" {
  description = "Resource ID of the Event Hub Namespace (used for role assignments)."
  value       = azurerm_eventhub_namespace.main.id
}

output "namespace_fqdn" {
  description = "Fully qualified domain name of the Event Hub Namespace."
  value       = "${azurerm_eventhub_namespace.main.name}.servicebus.windows.net"
}
