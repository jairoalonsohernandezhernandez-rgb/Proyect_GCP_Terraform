variable "project_id" {
  description = "Id del proyecto"
  type        = string
}

variable "sa_name" {
  description = "Nombre del servicio de cuenta"
  type        = string
  default     = "vertex-ai-runner-sa"
}

variable "region" {
  description = "Region donde se implementá la infraestructura"
  type        = string
  default     = "us-central1"
}