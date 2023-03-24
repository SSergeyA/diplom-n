output "internal_ip_address_k8s_instance" {
  value = {
    for node in yandex_compute_instance.k8s_instance:
        node.hostname => node.network_interface.0.ip_address
  }
}

output "external_ip_address_k8s_instance" {
  value = {
    for node in yandex_compute_instance.k8s_instance:
        node.hostname => node.network_interface.0.nat_ip_address
  }
}
