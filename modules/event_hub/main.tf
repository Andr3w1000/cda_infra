resource "azurerm_eventhub_namespace" "main" {
  name                = "evhns-${var.project}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.namespace_sku
  capacity            = var.namespace_capacity

  tags = var.tags
}

resource "azurerm_eventhub" "main" {
  name              = "evh-${var.project}-${var.environment}"
  namespace_id      = azurerm_eventhub_namespace.main.id
  partition_count   = var.partition_count
  message_retention = var.message_retention_days
}
