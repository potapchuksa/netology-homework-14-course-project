resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.ini.tftpl", {
    bastion_public_ip     = yandex_compute_instance.bastion.network_interface[0].nat_ip_address

    web_01_private_ip     = yandex_compute_instance.web-01.network_interface[0].ip_address
    web_02_private_ip     = yandex_compute_instance.web-02.network_interface[0].ip_address

    prometheus_private_ip = yandex_compute_instance.prometheus.network_interface[0].ip_address
    elasticsearch_private_ip = yandex_compute_instance.elasticsearch.network_interface[0].ip_address
    grafana_public_ip     = yandex_compute_instance.grafana.network_interface[0].ip_address
    kibana_public_ip      = yandex_compute_instance.kibana.network_interface[0].ip_address
  })

  filename = "../ansible/inventory.ini"
}
