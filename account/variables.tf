variable "subscription_id" {
  description = "Azure Subscription ID where account-level resources will be deployed."
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure AD tenant ID used to authenticate the Databricks account-level provider."
  type        = string
  sensitive   = true
}

variable "databricks_account_id" {
  description = "Databricks account ID (UUID found at accounts.azuredatabricks.net)."
  type        = string
}

variable "project" {
  description = "Short project name used in resource naming (lowercase, no spaces)."
  type        = string
  default     = "cda"
}

variable "location" {
  description = "Azure region for all resources (e.g. 'westeurope')."
  type        = string
  default     = "westeurope"
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default = {
    project    = "cda"
    managed_by = "terraform"
  }
}
