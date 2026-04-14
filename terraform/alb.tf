# 1. Target Group
resource "yandex_alb_target_group" "web_tg" {
  name        = "web-tg"
  description = "Target group for Nginx web servers"

  target {
    subnet_id = yandex_vpc_subnet.private_a.id
    ip_address   = yandex_compute_instance.web-01.network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.private_b.id
    ip_address   = yandex_compute_instance.web-02.network_interface[0].ip_address
  }
}

# 2. Backend Group
resource "yandex_alb_backend_group" "web_bg" {
  name        = "web-bg"
  description = "Backend group with health checks for web servers"

  http_backend {
    name   = "web-backend"
    weight = 1
    port   = 80
    target_group_ids = [ yandex_alb_target_group.web_tg.id ]

    load_balancing_config {
      panic_threshold = 50
    }

    healthcheck {
      timeout            = "10s"
      interval           = "15s"
      healthy_threshold  = 2
      unhealthy_threshold = 3

      http_healthcheck {
        path = "/"
      }
    }
  }
}

# 3. HTTP Router
resource "yandex_alb_http_router" "http_router" {
  name        = "http-router"
  description = "Routes all traffic to web backend"
}

resource "yandex_alb_virtual_host" "vh_web" {
  name           = "vh-web"
  http_router_id = yandex_alb_http_router.http_router.id

  route {
    name = "route-to-web"


    http_route {
      http_match {
        path {
          exact = "/"
        }
      }

      http_route_action { backend_group_id = yandex_alb_backend_group.web_bg.id }

    }
  }
}

# 4. Application Load Balancer
resource "yandex_alb_load_balancer" "alb" {
  name        = "alb"
  description = "Public ALB for high-availability website"
  network_id = yandex_vpc_network.main_vpc.id
  security_group_ids = [ yandex_vpc_security_group.alb_sg.id ]

  allocation_policy {
    location {
      zone_id   = "ru-central1-d"
      subnet_id = yandex_vpc_subnet.public.id 
    }
  }

  listener {
    name = "http-listener"

    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [ 80 ]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.http_router.id
      }
    }
  }
}
