# создаю сеть
resource "yandex_vpc_network" "network-1" {
  name = "network_dp"
}
# создаю private подсеть в 3 зонах
resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
  depends_on = [
    yandex_vpc_network.network-1,
  ]
}
resource "yandex_vpc_subnet" "subnet2" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.110.0/24"]
  depends_on = [
    yandex_vpc_network.network-1,
  ]
}
resource "yandex_vpc_subnet" "subnet3" {
  name           = "subnet-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.210.0/24"]
  depends_on = [
    yandex_vpc_network.network-1,
  ]
}
