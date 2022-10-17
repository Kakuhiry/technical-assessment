resource "google_project_service" "secretmanager" {
  service  = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_secret_manager_secret" "my-secret" {
  provider = google

  secret_id = "my-secret"

  replication {
    automatic = true
  }

  depends_on = [google_project_service.secretmanager]
}