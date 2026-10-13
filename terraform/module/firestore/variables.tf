variable "project_id" {
  description = "Id del proyecto"
  type        = string
}

variable "name_database" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "(default)"
}

variable "region" {
  description = "Región donde se desplegará el proyecto"
  type        = string
  default     = "us-central1"
}

variable "deletion_policy" {
  description = "Política de protección de borrado"
  type        = string
  default     = "ABANDON"
}