resource "google_api_gateway_api" "api" {
  provider     = google-beta
  project      = var.project_id
  api_id       = var.api_id
  display_name = "Portafolio API Gateway"
}

resource "google_api_gateway_api_config" "api_config" {
  provider      = google-beta
  project       = var.project_id
  api           = google_api_gateway_api.api.id
  api_config_id = "${var.api_id}-config-v1"
  display_name  = "Portafolio API Gateway Config v1"

  openapi_documents {
    document {
      path     = "openapi.yaml"
      contents = filebase64("${path.module}/openai.yaml")
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "gateway" {
  provider   = google-beta
  project    = var.project_id
  region     = var.region
  gateway_id = var.gateway_id
  api_config = google_api_gateway_api_config.api_config.id
}