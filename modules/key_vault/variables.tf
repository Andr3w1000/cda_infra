variable "project" {
  description = "Short project name used in resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, uat, prod)."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  description = "Key Vault SKU. 'standard' or 'premium'."
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Soft-delete retention period in days (7–90)."
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Enable purge protection (irreversible — use false for dev/uat)."
  type        = bool
  default     = false
}
