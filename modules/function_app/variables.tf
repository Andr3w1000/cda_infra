variable "project" {
  description = "Short project name used in resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, prod)."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to deploy into."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources in this module."
  type        = map(string)
  default     = {}
}

variable "sku" {
  description = "App Service Plan SKU. Must be B1 or higher to support always_on."
  type        = string
  default     = "B1"
}

variable "python_version" {
  description = "Python version for the Function App runtime."
  type        = string
  default     = "3.11"
}

variable "eventhub_namespace_fqdn" {
  description = "Fully qualified domain name of the Event Hub Namespace (e.g. <name>.servicebus.windows.net)."
  type        = string
}

variable "eventhub_name" {
  description = "Name of the Event Hub injected as an app setting."
  type        = string
}
