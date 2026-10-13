variable "zone_name" {
  description = "Nombre de la zona donde se aloja la app"
  type        = string
  default     = "zone-dns-project-001"
}

variable "project_id" {
  description = "Id del proyecto"
  type        = string
}

variable "domain_name" {
  description = "Nombre del dominio"
  type        = string
}

variable "lb_ip_address" {
  description = "Ip de la direccion del load balancer"
  type        = string
}