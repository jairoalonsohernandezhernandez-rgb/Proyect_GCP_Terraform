output "database_id" {
  description = "Id de la base de datos"
  value       = google_firestore_database.database.id
}

output "database_name" {
  description = "Nombre de la base de datos"
  value       = google_firestore_database.database.name
}

output "location_id" {
  description = "Ubicacion de la base de datos"
  value       = google_firestore_database.database.location_id
}