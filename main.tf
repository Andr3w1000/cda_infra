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

# Grant the Function App's managed identity send-only access to the Event Hub Namespace.
resource "azurerm_role_assignment" "function_app_eventhub_sender" {
  scope                = module.event_hub.namespace_id
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = module.function_app.principal_id
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

resource "azuread_application" "databricks_jobs" {
  display_name = "sp-${var.project}-${var.environment}-databricks"
}

resource "azuread_service_principal" "databricks_jobs" {
  client_id = azuread_application.databricks_jobs.client_id
}

resource "azuread_application_password" "databricks_jobs" {
  application_id = azuread_application.databricks_jobs.id
}

# Register the SP inside the Databricks workspace.
resource "databricks_service_principal" "databricks_jobs" {
  application_id = azuread_application.databricks_jobs.client_id
  display_name   = azuread_application.databricks_jobs.display_name

  depends_on = [module.databricks]
}

# Grant workspace admins the ServicePrincipalUser role so they can set this SP as the job runner.
resource "databricks_access_control_rule_set" "databricks_jobs_sp_user" {
  provider = databricks.account
  name     = "accounts/${var.databricks_account_id}/servicePrincipals/${azuread_application.databricks_jobs.client_id}/ruleSets/default"

  grant_rules {
    principals = ["groups/accountAdminGroup"]
    role       = "roles/servicePrincipal.user"
  }
}

# Grant the SP Contributor access on the Databricks workspace so it can submit jobs.
resource "azurerm_role_assignment" "databricks_sp_contributor" {
  scope                = module.databricks.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.databricks_jobs.object_id
}

# Allow the deploying identity to write secrets into the Key Vault.
resource "azurerm_role_assignment" "deployer_kv_secrets_officer" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Store SP credentials in Key Vault so they can be referenced at runtime.
resource "azurerm_key_vault_secret" "databricks_sp_client_id" {
  name         = "databricks-sp-client-id"
  value        = azuread_application.databricks_jobs.client_id
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_secrets_officer]
}

resource "azurerm_key_vault_secret" "databricks_sp_client_secret" {
  name         = "databricks-sp-client-secret"
  value        = azuread_application_password.databricks_jobs.value
  key_vault_id = module.key_vault.id

  depends_on = [azurerm_role_assignment.deployer_kv_secrets_officer]
}
