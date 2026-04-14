# Main VPC network
resource "yandex_vpc_network" "main_vpc" {
  name = "main-vpc"
}

# NAT Gateway to enable outbound internet traffic from private subnets
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

# Route table configuring default route via NAT Gateway
resource "yandex_vpc_route_table" "private_route_table" {
  name       = "private-route-table"
  network_id = yandex_vpc_network.main_vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Two private subnets in different availability zones
resource "yandex_vpc_subnet" "private_a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main_vpc.id
  v4_cidr_blocks = ["10.0.10.0/24"]
  route_table_id = yandex_vpc_route_table.private_route_table.id
}

resource "yandex_vpc_subnet" "private_b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main_vpc.id
  v4_cidr_blocks = ["10.0.20.0/24"]
  route_table_id = yandex_vpc_route_table.private_route_table.id
}

# One public subnet for external access
resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.main_vpc.id
  v4_cidr_blocks = ["10.0.30.0/24"]
}

