# создаю сеть
resource "yandex_vpc_network" "network-1" {
  name = "network_ser"
}
# создаю private подсеть в 3 зонах
resource "yandex_vpc_subnet" "subnet-1a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
resource "yandex_vpc_subnet" "subnet-1b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.110.0/24"]
}
resource "yandex_vpc_subnet" "subnet-1c" {
  name           = "private-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.210.0/24"]
}
