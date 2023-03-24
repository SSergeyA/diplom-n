variable "service_account_key" {
  default     = ""
}
variable "cloud_id" {
  type        = string
  default     = "b1gd88frf016p6u7jbkb"
}
variable "folder_id" {
  type        = string
  default     = "b1gei3vd4ol9vg188m8e"
}
variable "zone" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}
variable "image_id" {
  type        = string
  default     = "fd89n8278rhueakslujo"
}
