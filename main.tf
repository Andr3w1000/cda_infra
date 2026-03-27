data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location

  tags = merge(var.tags, {
    project     = var.project
    environment = var.environment
  })
}

module "event_hub" {
  source = "./modules/event_hub"

  project             = var.project
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = azurerm_resource_group.main.tags

  namespace_sku          = var.eventhub_namespace_sku
  namespace_capacity     = var.eventhub_namespace_capacity
  partition_count        = var.eventhub_partition_count
  message_retention_days = var.eventhub_message_retention_days
}

module "function_app" {
  source = "./modules/function_app"

  project             = var.project
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = azurerm_resource_group.main.tags

  sku            = var.function_app_sku
  python_version = var.function_app_python_version

  eventhub_namespace_fqdn = module.event_hub.namespace_fqdn
  eventhub_name           = module.event_hub.eventhub_name
}

module "key_vault" {
  source = "./modules/key_vault"

  project             = var.project
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = azurerm_resource_group.main.tags

  sku_name                   = var.key_vault_sku
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  purge_protection_enabled   = var.key_vault_purge_protection_enabled
}

module "databricks" {
  source = "./modules/databricks"

  project             = var.project
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = azurerm_resource_group.main.tags

  sku = var.databricks_sku
}

# -------------------------------------------------------
# Service Principal — used to run Databricks jobs
# -------------------------------------------------------

module "databricks_sp" {
  source = "./modules/databricks_sp"

  providers = {
    databricks         = databricks
    databricks.account = databricks.account
  }

  project               = var.project
  environment           = var.environment
  databricks_account_id = var.databricks_account_id

  depends_on = [module.databricks]
}

