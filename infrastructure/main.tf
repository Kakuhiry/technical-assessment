provider "google" {
    project = var.GCLOUD_PROJECT
    credentials = var.GOOGLE_APPLICATION_CREDENTIALS
    region = var.GCLOUD_REGION
  
}
resource "google_compute_instance" "vm" {
  name         = "vm"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_filepath)}"
  }

  metadata_startup_script = "echo ${file(var.startup_script)} > /script.sh"
}

