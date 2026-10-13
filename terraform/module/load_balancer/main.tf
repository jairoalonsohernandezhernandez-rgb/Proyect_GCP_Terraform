resource "google_compute_global_address" "default" {
  name    = "${var.name_prefix}-pip"
  project = var.project_id
}
