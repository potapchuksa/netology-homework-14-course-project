output "alb_public_ip" {
  description = "Public IPv4-address Application Load Balancer"
  value       = yandex_alb_load_balancer.alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
  sensitive   = false
}

output "bastion_public_ip" {
  description = "Public IPv4-address Bastion"
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  sensitive   = false
}

output "grafana_public_ip" {
  description = "Public IPv4-address Grafana"
  value       = yandex_compute_instance.grafana.network_interface[0].nat_ip_address
  sensitive   = false
}

output "kibana_public_ip" {
  description = "Public IPv4-address Kibana"
  value       = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
  sensitive   = false
}

output "alb_status" {
  description = "Status ALB"
  value       = yandex_alb_load_balancer.alb.status
}
