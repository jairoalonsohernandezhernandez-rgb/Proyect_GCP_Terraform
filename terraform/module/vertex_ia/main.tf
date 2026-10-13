resource "google_project_service" "vertex_ai_api" {
  project            = var.project_id
  service            = "aiplatform.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "vertex_sa" {
  project      = var.project_id
  account_id   = var.sa_name
  display_name = "Service Account para acceso a Vertex AI  desde la App"
}

resource "google_project_iam_member" "vertex_user_role" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.vertex_sa.email}"
  role    = "roles/aiplatform.user"
}

resource "google_service_account_iam_member" "workload_identity" {
  service_account_id = google_service_account.vertex_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[portfolio-app/portfolio-sa]"
}