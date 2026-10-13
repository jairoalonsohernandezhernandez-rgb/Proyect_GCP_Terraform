output "policy_id" {
  description = "ID de la politica de seguridad de CLoud Armor"
  value       = google_compute_security_policy.policy.id
}

output "policy_name" {
  description = "Nombre de la politica de seguridad de CLoud Armor"
  value       = google_compute_security_policy.policy.name
}