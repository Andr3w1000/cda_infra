output "object_id" {
  description = "Object ID of the service principal in Azure AD."
  value       = azuread_service_principal.this.object_id
}

output "display_name" {
  description = "Display name of the service principal."
  value       = azuread_application.this.display_name
}
