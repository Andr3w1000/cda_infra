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

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}

variable "sku" {
  description = "Databricks workspace SKU. 'standard', 'premium', or 'trial'."
  type        = string
  default     = "standard"
}
