terraform {
  required_version = ">= 1.15.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source       = "../../module/VPC"
  vpc_name     = "reglas-firewall-001"
  region       = var.region
  service_cidr = var.service_cidr
  pods_cidr    = var.pods_cidr
  subnet_cidr  = var.subnet_cidr
  project_id   = var.project_id
}

module "cloud_armor" {
  source      = "../../module/cloud_armor"
  project_id  = var.project_id
  policy_name = "cloud-armor-portfolio-dev"
}

module "api_gateway" {
  source     = "../../module/api_gateway"
  region     = var.region
  project_id = var.project_id
  api_id     = "id-api-jairo-001"
  gateway_id = "id-gateway-dev-alonso-001"
}

module "load_balancer" {
  source      = "../../module/load_balancer"
  project_id  = var.project_id
  name_prefix = "load-balancer-jairo-uno"
}

module "gke" {
  source                = "../../module/gke"
  region                = var.region
  project_id            = var.project_id
  subnet_id             = module.vpc.subnet_id
  network_id            = module.vpc.network_id
  service_ip_range_name = module.vpc.service_ip_range_name
  pods_ip_range_name    = module.vpc.pods_ip_range_name
  cluster_name          = "gke-primer-kubernets-001"
  node_count            = 1
  machine_type          = "e2-medium"
}

module "firestore" {
  source          = "../../module/firestore"
  region          = var.region
  project_id      = var.project_id
  deletion_policy = "ABANDON"
  name_database   = "(default)"
}

module "dns" {
  source        = "../../module/dns"
  project_id    = var.project_id
  lb_ip_address = module.load_balancer.public_ip
  zone_name     = "zone-dns-project-001"
  domain_name   = "midominio.com."
}

module "vertexAI" {
  source     = "../../module/vertex_ia"
  project_id = var.project_id
  sa_name    = "vertex-ai-runner-sa"
  region     = var.region
  depends_on = [module.gke]
}