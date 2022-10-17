provider "google" {
    project = var.GCLOUD_PROJECT
    credentials = var.GOOGLE_APPLICATION_CREDENTIALS
    region = var.GCLOUD_REGION
}

resource "google_compute_instance" "vm" {
  name         = "vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20221015"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("./utils/ubuntu")}"
    host = "${google_compute_instance.vm.network_interface.0.access_config.0.nat_ip}"
  }
  
  provisioner "file" {
    source = "./nginx.conf"
    destination = "/home/ubuntu/nginx.conf"
  }
  provisioner "file" {
    source = "./utils/credentials.json"
    destination = "/home/ubuntu/creds.json"
  }
  provisioner "file" {
    source = "./startup.sh"
    destination = "/home/ubuntu/startup.sh"
  }
  provisioner "file" {
    source = "../.env"
    destination = "/home/ubuntu/.env"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sleep 160",
      "git clone https://github.com/Kakuhiry/technical-assessment.git",
      "sudo mv .env /home/ubuntu/technical-assessment/.env",
      "sudo mv /home/ubuntu/nginx.conf /home/ubuntu/technical-assessment/nginx.conf",
      "sudo docker-compose -f technical-assessment/docker-compose.yml up --scale app=2 -d",
    ]
  }

  tags = ["http-server", "https-server"]
  metadata_startup_script = "${file(var.startup_script)}"
  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_filepath)}"
  }
}

resource "google_secret_manager_secret_version" "my-secret-1" {
  provider = google
  secret      = google_secret_manager_secret.my-secret.id
  secret_data = "${google_compute_instance.vm.network_interface.0.access_config.0.nat_ip}"
}

