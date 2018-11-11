provider "google" {
  project = "cloud2018-list2"
  region = "europe-west4"
}

module "www_servers" {
  source = "./www_module/"
  
  main_server_type = "f1-micro"
  servers_number = 1
}

output "www_public_ips" {
  value = "${module.www_servers.server_public_ips}"
}

output "www_private_ips" {
  value = "${module.www_servers.server_private_ips}"
}

