output "public_ip" {
  description = "IP pública asignada a Load Balancer"
  value       = google_compute_global_address.default.address
}
