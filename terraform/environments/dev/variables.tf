variable "project_id" {
  description = "ID del proyecto"
  type        = string
}

variable "region" {
  description = "Región donde se implementará la infraestructura"
  type        = string
  default     = "us-central1"
}

variable "subnet_cidr" {
  description = "CIDR de la subnet de red"
  type        = string
  default     = "10.0.0.0/20"
}

variable "pods_cidr" {
  description = "CIDR para los pods"
  type        = string
  default     = "10.4.0.0/14"
}

variable "service_cidr" {
  description = "CIDR del servicio"
  type        = string
  default     = "10.8.0.0/20"
}

