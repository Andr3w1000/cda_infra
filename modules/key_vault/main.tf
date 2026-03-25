# Key Vault names must be globally unique, 3–24 chars, alphanumeric and hyphens only.
resource "random_string" "kv_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_key_vault" "main" {
  name                = "kv-${var.project}-${var.environment}-${random_string.kv_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  # Use Azure RBAC for access control instead of legacy vault access policies.
  rbac_authorization_enabled = true

  tags = var.tags
}
