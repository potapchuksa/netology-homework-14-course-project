variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
  sensitive   = true
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
  sensitive   = true
}

variable "default_zone" {
  type        = string
  description = "Default zone for resources"
  default     = "ru-central1-d"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR format (/32 for single IP)"
  type        = string
  default     = "0.0.0.0/0"
}
