output "cluster_name" {
  description = "Nombre del cluster de GKE"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "Endpoint del cluster de GKE"
  value       = google_container_cluster.primary.endpoint
}

output "ca_certificate" {
  description = "Certificado CA del cluster de GKE"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}