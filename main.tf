provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = "terrakube"
  mtu                     = 1460
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "terrakube" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-north2"
  network       = google_compute_network.vpc_network.id
  project       = var.project_id
}

resource "google_compute_firewall" "default" {
  name    = "common-ports"
  network = google_compute_network.vpc_network.name
  description = "Allow Web, Mosh, SSH and internal traffic"
  source_ranges = [ "0.0.0.0/0" ]
  target_tags = ["ssh"]

  allow {
    protocol = "udp"
    ports = ["60000-61000"]
}
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }
}

resource "google_compute_firewall" "internal-traffic" {
  name    = "internal-taffic"
  network = google_compute_network.vpc_network.name
  description = "Allow internal traffic"
  source_ranges = [ "10.0.0.0/8" ]
  target_tags = ["node"]

  allow {
    protocol = "udp"
    ports = ["1-65535"]
  }
  allow {
    protocol = "tcp"
    ports = ["1-65535"]
}

}

resource "google_compute_address" "external-address" {
  count = "${var.control-nodes-number + 1}"

  name = "note-address-${count.index + 1}"
  project = var.project_id
  region = var.region
  depends_on = [ google_compute_firewall.default ]
}

data "google_compute_image" "master-node" {
  filter  = "name eq default-node.*"
  project = var.project_id
  most_recent = "true"
}

resource "google_compute_instance" "master-node" {
  name         = "master-node"
  project = var.project_id
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["ssh", "master-node", "node"]
  labels = {
    name = "master-node"
  }

  metadata = {
    ssh-keys = "admin:${var.ssh_pubkey}"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.terrakube.self_link
    access_config {
      nat_ip = google_compute_address.external-address[0].address
    }
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.master-node.self_link
    }
  }
  depends_on = [ google_compute_firewall.default, google_compute_subnetwork.terrakube ]
}

resource "google_compute_instance" "worker-node" {
  count = var.control-nodes-number

  name         = "worker-node-${count.index}"
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["ssh", "worker-node", "node"]
  labels = {
    name = "master-node"
  }

  metadata = {
    ssh-keys = "admin:${var.ssh_pubkey}"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.terrakube.self_link
    access_config {
      nat_ip = google_compute_address.external-address[count.index + 1].address
    }
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.master-node.self_link
    }
  }
  depends_on = [ google_compute_firewall.default, google_compute_subnetwork.terrakube ]
}
