output "service_account_email" {
  description = "Email de la cuenta de servicio"
  value       = google_service_account.vertex_sa.email
}

output "service_account_id" {
  description = "ID de la cuenta de servicios"
  value       = google_service_account.vertex_sa.id
}