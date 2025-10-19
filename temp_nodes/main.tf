

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}


data "google_compute_network" "terracube" {
  name = "terrakube"
}

data "google_compute_subnetworks" "terracube-subnet" {
  filter  = "ipCidrRange eq ${var.ip_cidr}"
  project = var.project_id
  region = var.region
}

data "google_compute_image" "golden-image" {
  filter  = "name eq default-node.*"
  project = var.project_id
  most_recent = "true"
}

resource "google_compute_firewall" "internal-traffic-temp" {
  name    = "internal-taffic-temp"
  network = data.google_compute_network.terracube.name
  description = "Allow internal traffic"
  source_ranges = [ "10.0.0.0/8" ]
  target_tags = ["node-temp"]

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

  name = "note-address-temp-${count.index + 1}"
  project = var.project_id
  region = var.region
  depends_on = [ google_compute_firewall.internal-traffic-temp ]
}



resource "google_compute_instance" "worker-node" {
  count = var.control-nodes-number

  name         = "worker-node-${count.index}-temp"
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["ssh", "worker-node", "node-temp"]
  labels = {
    name = "master-node"
  }

  metadata = {
    ssh-keys = "admin:${var.ssh_pubkey}"
  }

  network_interface {
    subnetwork = data.google_compute_subnetworks.terracube-subnet.subnetworks[0].self_link
    access_config {
      nat_ip = google_compute_address.external-address[count.index + 1].address
    }
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.golden-image.self_link
    }
  }
  depends_on = [ google_compute_firewall.internal-traffic-temp ]
}
