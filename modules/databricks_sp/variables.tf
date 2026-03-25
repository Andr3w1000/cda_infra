variable "project" {
  description = "Short project name used in resource naming (lowercase, no spaces)."
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, uat, prod)."
  type        = string
}

variable "databricks_account_id" {
  description = "Databricks account ID (UUID found at accounts.azuredatabricks.net)."
  type        = string
}
