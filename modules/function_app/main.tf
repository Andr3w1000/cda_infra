# Storage account names must be globally unique, 3–24 chars, lowercase alphanumeric only.
resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "main" {
  name                     = "st${var.project}${var.environment}${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# Basic B1 is the cheapest App Service Plan tier that supports always_on,
# which is required for a continuously running function.
resource "azurerm_service_plan" "main" {
  name                = "asp-${var.project}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku

  tags = var.tags
}

resource "azurerm_linux_function_app" "main" {
  name                = "func-${var.project}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id            = azurerm_service_plan.main.id
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true # Keeps the function alive; requires B1 or higher

    application_stack {
      python_version = var.python_version
    }
  }

  app_settings = {
    # Managed Identity connection — no secrets needed
    "EventHubConnection__fullyQualifiedNamespace" = var.eventhub_namespace_fqdn
    "EventHubName"                                = var.eventhub_name
    "FUNCTIONS_WORKER_RUNTIME"                    = "python"
  }

  tags = var.tags
}
