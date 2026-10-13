output "name_servers" {
  description = "Nombre de los servidores de DNS"
  value       = google_dns_managed_zone.primary.name_servers
}

output "zone_id" {
  description = "Zona donde se alojaŕa la app web con DNS"
  value       = google_dns_managed_zone.primary.id
}