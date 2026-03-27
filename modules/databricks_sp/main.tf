resource "azuread_application" "this" {
  display_name = "sp-${var.project}-${var.environment}-databricks"
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

resource "databricks_service_principal" "this" {
  application_id = azuread_application.this.client_id
  display_name   = azuread_application.this.display_name
}

resource "databricks_access_control_rule_set" "this" {
  provider   = databricks.account
  depends_on = [databricks_service_principal.this]
  name       = "accounts/${var.databricks_account_id}/servicePrincipals/${azuread_application.this.client_id}/ruleSets/default"

  grant_rules {
    principals = ["groups/accountAdminGroup"]
    role       = "roles/servicePrincipal.user"
  }
}
