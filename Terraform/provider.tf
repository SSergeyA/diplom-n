provider "yandex" {
  service_account_key_file = var.service_account_key
  //service_account_key_file ="key.json"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}
