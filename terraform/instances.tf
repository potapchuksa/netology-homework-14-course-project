//
// Get information about existing Compute Image
//
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

locals {
  ssh_keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
}

resource "yandex_compute_instance" "web-01" {
  name        = "web-01"
  hostname    = "web-01"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  scheduling_policy { preemptible = true }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id           = yandex_vpc_subnet.private_a.id
    security_group_ids  = [yandex_vpc_security_group.web-sg.id]
    nat                 = false
  }

  metadata = {
    ssh-keys = local.ssh_keys
  }
}

resource "yandex_compute_instance" "web-02" {
  name        = "web-02"
  hostname    = "web-02"
  zone        = "ru-central1-b"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  scheduling_policy { preemptible = true }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id           = yandex_vpc_subnet.private_b.id
    security_group_ids  = [yandex_vpc_security_group.web-sg.id]
    nat                 = false
  }

  metadata = {
    ssh-keys = local.ssh_keys
  }
}

resource "yandex_compute_instance" "prometheus" {
  name        = "prometheus"
  hostname    = "prometheus"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  scheduling_policy { preemptible = true }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id           = yandex_vpc_subnet.private_a.id
    security_group_ids  = [yandex_vpc_security_group.prometheus-sg.id]
    nat                 = false
  }

  metadata = {
    ssh-keys = local.ssh_keys
  }
}

resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  hostname    = "elasticsearch"
  zone        = "ru-central1-b"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  scheduling_policy { preemptible = true }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type     = "network-hdd"
      size     = 30
    }
  }

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id           = yandex_vpc_subnet.private_b.id
    security_group_ids  = [yandex_vpc_security_group.elasticsearch-sg.id]
    nat                 = false
  }

  metadata = {
    ssh-keys = local.ssh_keys
  }
}

resource "yandex_compute_instance" "grafana" {
  name        = "grafana"
  hostname    = "grafana"
  zone        = "ru-central1-d"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  scheduling_policy { preemptible = true }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type     = "network-hdd"
      size     = 15
    }
  }

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id           = yandex_vpc_subnet.public.id
    security_group_ids  = [yandex_vpc_security_group.grafana-sg.id]
    nat                 = true
  }

  metadata = {
    ssh-keys = local.ssh_keys
  }
}

resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana"
  zone        = "ru-central1-d"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  scheduling_policy { preemptible = true }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type     = "network-hdd"
      size     = 15
    }
  }

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id           = yandex_vpc_subnet.public.id
    security_group_ids  = [yandex_vpc_security_group.kibana-sg.id]
    nat                 = true
  }

  metadata = {
    ssh-keys = local.ssh_keys
  }
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  zone        = "ru-central1-d"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }

  scheduling_policy { preemptible = true }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id           = yandex_vpc_subnet.public.id
    security_group_ids  = [yandex_vpc_security_group.bastion-sg.id]
    nat                 = true
  }

  metadata = {
    ssh-keys = local.ssh_keys
  }
}

