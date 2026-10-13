output "network_id" {
  description = "ID de la red VPC"
  value       = google_compute_network.vpc_network.id
}

output "network_name" {
  description = "Nombre de la red VPC"
  value       = google_compute_network.vpc_network.name
}

output "subnet_id" {
  description = "ID de la subnet"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_name" {
  description = "Nombre de la subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "pods_ip_range_name" {
  description = "Nombre del rango de IPs para los pods"
  value       = google_compute_subnetwork.subnet.secondary_ip_range[0].range_name
}

output "service_ip_range_name" {
  description = "Nombre del rango de IPs para los servicios"
  value       = google_compute_subnetwork.subnet.secondary_ip_range[1].range_name
}