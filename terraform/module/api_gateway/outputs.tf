output "gateway_url" {
  description = "URL de la gateway"
  value       = google_api_gateway_gateway.gateway.default_hostname
}

output "gateway_id" {
  description = "ID de el gateway"
  value       = google_api_gateway_gateway.gateway.gateway_id
}