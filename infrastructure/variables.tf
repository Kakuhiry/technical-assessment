locals {
    envs = { for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => tuple[1] }
}

variable "ssh_public_key_filepath" {
  description = "ssh public key that will be used to connect to VM"
  default = "./auth/ubuntu.pub"
}

variable "startup_script" {
    description = "Startup script to install all components needed"
    default = "./startup.sh"
}

variable GOOGLE_APPLICATION_CREDENTIALS {
  description = "Credentials for Gcloud authentication"
  default = "./auth/credentials.json"
}

variable "GCLOUD_PROJECT" {
  default = "serious-dialect-365703"
  description = "Gcloud project name"
}

variable "GCLOUD_REGION" {
  description = "Gcloud project region"
  default = "us-central1"
}