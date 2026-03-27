resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.project}-databricks-account"
  location = var.location
  tags     = var.tags
}

# -------------------------------------------------------
# Metastore root storage (ADLS Gen2)
# -------------------------------------------------------

resource "azurerm_storage_account" "metastore" {
  name                     = "st${var.project}uc${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
  tags                     = var.tags
}

resource "azurerm_storage_container" "metastore" {
  name               = "metastore"
  storage_account_id = azurerm_storage_account.metastore.id
}

# -------------------------------------------------------
# Access Connector — managed identity for Unity Catalog
# -------------------------------------------------------

resource "azurerm_databricks_access_connector" "this" {
  name                = "ac-${var.project}-uc"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

# -------------------------------------------------------
# Unity Catalog metastore
# -------------------------------------------------------

resource "databricks_metastore" "this" {
  name         = "${var.project}-metastore"
  region       = var.location
  storage_root = "abfss://${azurerm_storage_container.metastore.name}@${azurerm_storage_account.metastore.name}.dfs.core.windows.net/"
  force_destroy = false

  depends_on = [azurerm_role_assignment.access_connector_storage]
}

resource "databricks_storage_credential" "this" {
  name         = azurerm_databricks_access_connector.this.name
  metastore_id = databricks_metastore.this.id

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this.id
  }

  comment = "Managed identity credential for Unity Catalog metastore root storage."
}

resource "databricks_external_location" "metastore_root" {
  name            = "metastore-root"
  metastore_id    = databricks_metastore.this.id
  url             = "abfss://${azurerm_storage_container.metastore.name}@${azurerm_storage_account.metastore.name}.dfs.core.windows.net/"
  credential_name = databricks_storage_credential.this.name
  comment         = "Root storage for the Unity Catalog metastore."
}
