variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
}

variable "project_id" {
  description = "ID del proyecto"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR de la subred"
  type        = string
}

variable "pods_cidr" {
  description = "CIDR para los pods de Kubernetes"
  type        = string
}

variable "region" {
  description = "Region de despliegue"
  type        = string
}

variable "service_cidr" {
  description = "CIDR para los servicios de Kubernetes"
  type        = string
}