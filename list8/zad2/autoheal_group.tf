provider "google" {
  project = "cloud2018-list2"
  region = "europe-west4"
}

variable "region_name" {
  description = "Name of region to launch instances in."
  default     = "europe-north1"
}

variable "servers_number" {
  description = "Number of instances to create."
  default     = 2
}

variable "server_type" {
  description = "Server type to use."
  default     = "f1-micro"
}

locals {
  zone = "${var.region_name}-a"
}

data "google_compute_image" "template-image" {
    name = "template-8-2"
}

resource "google_compute_instance_template" "instance-template" {
  name_prefix  = "instance-template-"
  machine_type = "${var.server_type}"
  region       = "${var.region_name}"
  tags = ["http-server"]

  // Create a new boot disk from an image
  disk {
    source_image = "${data.google_compute_image.template-image.name}"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
  }
}

resource "google_compute_instance_group_manager" "managed-group" {
  name = "managed-group"

  base_instance_name = "app"
  instance_template  = "${google_compute_instance_template.instance-template.self_link}"
  update_strategy    = "REPLACE"
  zone               = "${local.zone}"

  # target_pools = ["${google_compute_target_pool.default.self_link}"]
  target_size  = "${var.servers_number}"

}

# resource "google_compute_target_pool" "default" {
#   name = "instance-pool"
#   region = "${var.region_name}"

#   health_checks = [
#     "${google_compute_http_health_check.default.name}",
#   ]
# }

# resource "google_compute_http_health_check" "default" {
#   name               = "default"
#   request_path       = "/"
#   check_interval_sec = 1
#   timeout_sec        = 1
# }

# resource "google_compute_forwarding_rule" "to-selfhealing" {
#   name       = "to-selfhealing"
#   # target     = "${google_compute_target_pool.default.self_link}"
#   backend_service = "${google_compute_backend_service.lb-backend.self_link}"
#   # port_range = "80"
#   ports = [80]
#   ip_address = "${google_compute_address.public_ip.address}"
#   region     = "${var.region_name}"
#   load_balancing_scheme = "EXTERNAL"
# }

# resource "google_compute_address" "public_ip" {
#   name         = "forwarding-rule"
#   address_type = "EXTERNAL"
#   region       = "${var.region_name}"
# }

resource "google_compute_backend_service" "lb-backend" {
  name        = "lb-backend"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 5
  enable_cdn  = false
  # region      = "${var.region_name}"

  backend {
    group = "${google_compute_instance_group_manager.managed-group.instance_group}"
  }

  health_checks = ["${google_compute_health_check.health-check.self_link}"]
}


  # health_checks = ["${google_compute_http_health_check.default.self_link}"]


resource "google_compute_health_check" "health-check" {
  name               = "health-check"
  # check_interval_sec = 10
  # timeout_sec        = 4
  # healthy_threshold = 1
  # unhealthy_threshold = 10

  http_health_check {
  }

    # tcp_health_check {
    #   port = 80
    # }
}

resource "google_compute_global_forwarding_rule" "http-rule" {
  name       = "http-rule"
  target     = "${google_compute_target_http_proxy.http-proxy.self_link}"
  port_range = "80"
  # ip_address = "${google_compute_address.public_ip.address}"
}

resource "google_compute_target_http_proxy" "http-proxy" {
  name        = "http-proxy"
  url_map     = "${google_compute_url_map.http-forwarder.self_link}"
}

resource "google_compute_url_map" "http-forwarder" {
  name            = "http-forwarder"
  default_service = "${google_compute_backend_service.lb-backend.self_link}"
}

output "public_ip" {
  value = "${google_compute_global_forwarding_rule.http-rule.ip_address}"
}