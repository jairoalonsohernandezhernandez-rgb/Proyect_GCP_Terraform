resource "google_dns_managed_zone" "primary" {
  name        = var.zone_name
  project     = var.project_id
  dns_name    = var.domain_name
  description = "Zona DNS pública para alojar app web del proyecto"
  visibility  = "public"
}

resource "google_dns_record_set" "a_record" {
  name         = google_dns_managed_zone.primary.dns_name
  managed_zone = google_dns_managed_zone.primary.name
  type         = "A"
  ttl          = 300
  project      = var.project_id

  rrdatas = [var.lb_ip_address]
}

resource "google_dns_record_set" "cname_www" {
  name         = "www.${google_dns_managed_zone.primary.dns_name}"
  managed_zone = google_dns_managed_zone.primary.name
  type         = "CNAME"
  ttl          = 300
  project      = var.project_id

  rrdatas = [google_dns_managed_zone.primary.dns_name]
}