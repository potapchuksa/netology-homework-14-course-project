# Security Groups for Coursework Infrastructure

# Common Network ID
locals {
  network_id = yandex_vpc_network.main_vpc.id
}

resource "yandex_vpc_security_group" "web-sg" {
  name        = "web-servers-sg"
  network_id  = local.network_id
  description = "Security group for Nginx web servers"

  ingress {
    protocol          = "TCP"
    description       = "HTTP from ALB public subnet"
    v4_cidr_blocks    = ["10.0.30.0/24"]
    port              = 80
  }

  ingress {
    protocol          = "TCP"
    description       = "Node Exporter from Prometheus"
    v4_cidr_blocks    = ["10.0.10.0/24"]
    port              = 9100
  }

  ingress {
    protocol          = "TCP"
    description       = "NginxLog Exporter from prometheus"
    port              = 4040
    v4_cidr_blocks    = ["10.0.10.0/24"]
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion only"
    v4_cidr_blocks    = ["10.0.30.0/24"]
    port              = 22
  }

  egress {
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    description       = "Allow all outbound"
  }
}

resource "yandex_vpc_security_group" "prometheus-sg" {
  name        = "prometheus-sg"
  network_id  = local.network_id
  description = "Allow scraping metrics from exporters"

  ingress {
    protocol          = "TCP"
    description       = "Prometheus Web UI from Grafana"
    v4_cidr_blocks    = ["10.0.30.0/24"]
    port              = 9090
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    v4_cidr_blocks    = ["10.0.30.0/24"]
    port              = 22
  }

  egress {
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    description       = "Allow all outbound (apt, updates)"
  }
}

resource "yandex_vpc_security_group" "elasticsearch-sg" {
  name        = "elasticsearch-sg"
  network_id  = local.network_id
  description = "Allow Filebeat to send logs to Elasticsearch"

  ingress {
    protocol          = "TCP"
    description       = "Elasticsearch API"
    v4_cidr_blocks    = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
    port              = 9200
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    v4_cidr_blocks    = ["10.0.30.0/24"]
    port              = 22
  }

  egress {
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    description       = "Outbound for updates"
  }
}

resource "yandex_vpc_security_group" "grafana-sg" {
  name        = "grafana-sg"
  network_id  = local.network_id
  description = "Allow access to Grafana web interface"

  ingress {
    protocol          = "TCP"
    description       = "Grafana Web UI"
    v4_cidr_blocks    = [var.my_ip_cidr]
    port              = 3000
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    v4_cidr_blocks    = ["10.0.30.0/24"]
    port              = 22
  }

  egress {
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    description       = "Allow outbound"
  }
}

resource "yandex_vpc_security_group" "kibana-sg" {
  name        = "kibana-sg"
  network_id  = local.network_id
  description = "Allow access to Kibana web interface"

  ingress {
    protocol          = "TCP"
    description       = "Kibana Web UI"
    v4_cidr_blocks    = [var.my_ip_cidr]
    port              = 5601
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    v4_cidr_blocks    = ["10.0.30.0/24"]
    port              = 22
  }

  egress {
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    description       = "Allow outbound"
  }
}

resource "yandex_vpc_security_group" "bastion-sg" {
  name        = "bastion-sg"
  network_id  = local.network_id
  description = "Only allow SSH to bastion from internet"

  ingress {
    protocol          = "TCP"
    description       = "SSH from Internet"
    v4_cidr_blocks    = [var.my_ip_cidr]
    port              = 22
  }

  egress {
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    description       = "Allow bastion to connect to private instances"
  }
}

resource "yandex_vpc_security_group" "alb_sg" {
  name        = "alb-security-group"
  network_id  = yandex_vpc_network.main_vpc.id
  description = "Allow HTTP from internet to ALB"

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Allow HTTP"
  }

  ingress {
    protocol       = "TCP"
    description    = "Health checks from Yandex Cloud control plane"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
    port           = 30080
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Allow all outbound"
  }
}

