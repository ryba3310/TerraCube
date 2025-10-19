

output "workers" {
  value = google_compute_instance.worker-node[*].network_interface.0.network_ip
}
