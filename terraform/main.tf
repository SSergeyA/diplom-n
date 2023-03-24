locals {
    subnet = [yandex_vpc_subnet.subnet1.id, yandex_vpc_subnet.subnet2.id, yandex_vpc_subnet.subnet3.id]
}
resource "yandex_compute_instance" "k8s_instance" {
  count = 3
  name     = "node-${count.index + 1}-${terraform.workspace}"
  hostname = "node-${count.index + 1}-${terraform.workspace}"
  zone     = var.zone[count.index]
  depends_on = [
    yandex_vpc_subnet.subnet1, yandex_vpc_subnet.subnet2, yandex_vpc_subnet.subnet3
  ]
  platform_id = "standard-v2"
  resources {
    cores  = 4
    memory = 8
    
  }

  boot_disk {
    initialize_params {
      image_id    = var.image_id
      size        = "20"
    }
  }

  network_interface {
    subnet_id = local.subnet[count.index]
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7Y1F7EjSw2sqlIM6/9+TeIn3YjNb9QjAxhe1ZgBeed9CcVPObV2zR+SCdc3AYXUqTU+6FFjTfhcyyRjX9ww+9TX10y2meLTKM2Vk3G71YDwI95aFoAks632wMuT9WJixlJyN5O9fr9Gm7BpxRQbsS+njJ70KQTEDMENrQwZlw979dTzch7st/SfNdGj0ScaN5Dr8gwCPDwdxIp3FuyWhxI4gToYOn4b9VSS/z64IkrCux1x7c+zRmbfdIAlWuY4C3ZMkdoWRc/CAEWZNP0I/8yPouZR7ijnZbubpy/6UmZzrS/S7/h9051czHB0nb8rAc8KI3Ear7xg2Wim/1Gwy21Ao7qq/iaPRl8sCapLKg/QzvvW3cv8JB9Vw9gMfE/fPBEWmeebJb9NihRzI1TWTEkcrUlSJ9QEjbQ8xRhZa7BEB9If98VhW/G//wa42sc5MpqgOdYxpIkmjWFJYhY2vFaqxBq/8vKSY2swlpNiQsQ65I4ibJYsRa6daWaCkOpac= sergey@sergey-ThinkPad-X201"
  }

}

