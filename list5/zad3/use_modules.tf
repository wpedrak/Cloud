provider "google" {
  project = "cloud2018-list2"
  region = "europe-west4"
}

locals {
  region = "europe-north1"
}


resource "google_compute_network" "www_network" {
  name                    = "list5"
  auto_create_subnetworks = "false"
}

module "www_servers" {
  source = "./www_module/"
  
  # server_type    = "f1-micro"
  # servers_number = 1
  image_name = "list5-www"
  network = "${google_compute_network.www_network.name}"
  region = "${local.region}"
}

module "load_balancer" {
  source = "./load_balancer_module/"
  
  # server_type    = "f1-micro"
  image_name = "list5-load-balancer"
  destination_ips = "${module.www_servers.server_private_ips}"
  network = "${google_compute_network.www_network.name}"
  region = "${local.region}"
}

output "www_private_ips" {
  value = "${module.www_servers.server_private_ips}"
}

output "load-balancer_ip" {
  value = "${module.load_balancer.public_ip}"
}
