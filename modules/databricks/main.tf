resource "azurerm_databricks_workspace" "main" {
  name                        = "dbw-${var.project}-${var.environment}"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = var.sku
  managed_resource_group_name = "${var.resource_group_name}-mrg"

  custom_parameters {
    no_public_ip = false
  }

  tags = var.tags
}
