resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-rule"
  network = "default"
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  source_tags = ["allow-http"]
  priority    = 1000

}