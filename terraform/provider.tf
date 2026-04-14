terraform {
  required_version = ">= 1.8.4"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.161.0"
    }
  }
}

# Configure Yandex Cloud provider
provider "yandex" {
  # Configuration options
  zone = var.default_zone
}
