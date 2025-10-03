provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

data "google_compute_image" "my_image" {
  filter  = "name eq packer.*"
  project = var.project_id
  most_recent = "true"
}


resource "google_compute_instance" "default" {
  name         = "master_node"
  machine_type = "e2-medium"
  zone         = var.zone

  network_interface = {
    network = "default"

}


  boot_disk {
    initialize_params {
      image = data.google_compute_image.master_node.self_link
    }
  }
}
