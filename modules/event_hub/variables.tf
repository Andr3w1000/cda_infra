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

variable "namespace_sku" {
  description = "Event Hub Namespace SKU (Basic or Standard)."
  type        = string
  default     = "Basic"
}

variable "namespace_capacity" {
  description = "Throughput units for the namespace."
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "Number of partitions. Cannot be changed after creation."
  type        = number
  default     = 2
}

variable "message_retention_days" {
  description = "Message retention in days (1 for Basic, up to 7 for Standard)."
  type        = number
  default     = 1
}
