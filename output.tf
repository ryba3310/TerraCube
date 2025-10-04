
output "master" {
  value = [google_compute_instance.master-node.network_interface.0.access_config.0.nat_ip]
}

output "workers" {
  value = google_compute_instance.worker-node[*].network_interface.0.access_config.0.nat_ip
}
