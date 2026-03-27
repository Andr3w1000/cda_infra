# -------------------------------------------------------
# Global
# -------------------------------------------------------

variable "subscription_id" {
  description = "Azure Subscription ID where resources will be deployed."
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment. Allowed values: dev, prod."
  type        = string
  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be one of: dev, uat, prod."
  }
}

variable "location" {
  description = "Azure region for all resources (e.g. 'West Europe', 'East US')."
  type        = string
  default     = "West Europe"
}

variable "project" {
  description = "Short project name used in resource naming (lowercase, no spaces)."
  type        = string
  default     = "cda"
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}

# -------------------------------------------------------
# Function App
# -------------------------------------------------------

variable "function_app_python_version" {
  description = "Python version for the Function App runtime."
  type        = string
  default     = "3.11"
}

variable "function_app_sku" {
  description = <<-EOT
    App Service Plan SKU. Must support always_on (i.e. B1 or higher).
    B1 (~$13/mo) is the cheapest tier that allows continuous execution.
  EOT
  type        = string
  default     = "B1"
}

# -------------------------------------------------------
# Event Hub
# -------------------------------------------------------

variable "eventhub_namespace_sku" {
  description = "Event Hub Namespace SKU. 'Basic' is the cheapest tier."
  type        = string
  default     = "Basic"
}

variable "eventhub_namespace_capacity" {
  description = "Throughput units for the Event Hub Namespace (1–20 for Basic/Standard)."
  type        = number
  default     = 1
}

variable "eventhub_partition_count" {
  description = "Number of partitions for the Event Hub (2–32). Cannot be changed after creation."
  type        = number
  default     = 2
}

variable "eventhub_message_retention_days" {
  description = "Message retention in days (1 for Basic, up to 7 for Standard)."
  type        = number
  default     = 1
}

# -------------------------------------------------------
# Databricks account
# -------------------------------------------------------

variable "azure_tenant_id" {
  description = "Azure AD tenant ID used to authenticate the Databricks account-level provider."
  type        = string
  sensitive   = true
}

variable "databricks_account_id" {
  description = "Databricks account ID (UUID found at accounts.azuredatabricks.net)."
  type        = string
}

# -------------------------------------------------------
# Key Vault
# -------------------------------------------------------

variable "key_vault_sku" {
  description = "Key Vault SKU. 'standard' or 'premium'."
  type        = string
  default     = "standard"
}

variable "key_vault_soft_delete_retention_days" {
  description = "Soft-delete retention period in days (7–90)."
  type        = number
  default     = 7
}

variable "key_vault_purge_protection_enabled" {
  description = "Enable purge protection (irreversible — use false for dev/uat)."
  type        = bool
  default     = false
}

# -------------------------------------------------------
# Owner
# -------------------------------------------------------

variable "owner_object_id" {
  description = "Azure AD object ID of the user running Terraform interactively (used for personal role assignments, e.g. Event Hub receiver)."
  type        = string
}

# -------------------------------------------------------
# Databricks
# -------------------------------------------------------

variable "metastore_id" {
  description = "Unity Catalog metastore ID. Get this from account/ outputs after running account/ apply first."
  type        = string
}

variable "databricks_sku" {
  description = "Databricks workspace SKU. 'standard', 'premium', or 'trial'."
  type        = string
  default     = "premium"
}
