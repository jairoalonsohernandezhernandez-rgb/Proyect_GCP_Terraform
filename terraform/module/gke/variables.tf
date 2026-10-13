variable "cluster_name" {
  description = "Nombre del cluster de GKE"
  type        = string
}

variable "region" {
  description = "Región de despliegue del cluster"
  type        = string
}

variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "network_id" {
  description = "ID de la red VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred"
  type        = string
}

variable "pods_ip_range_name" {
  description = "Nombre del rango de IPs para los pods"
  type        = string
}

variable "service_ip_range_name" {
  description = "Nombre del rango de IPs para los servicios"
  type        = string
}

variable "node_count" {
  description = "Número de nodos en el pool de nodos"
  type        = number
}

variable "machine_type" {
  description = "Tipo de máquina para los nodos"
  type        = string
}