variable "main_server_type" {
  description = "Server type to use for the main application server."
  default     = "f1-micro"
}

variable "servers_number" {
  description = "Number of servers to create"
  default     = 1
}

# resource "google_compute_address" "public_ip" {
#   count = "${var.servers_number}"
  
#   name         = "server-ip-${count.index}"
#   address_type = "EXTERNAL"
# }

resource "google_compute_network" "www_network" {
  name                    = "www-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "www_firewall" {
  name    = "test-firewall"
  network = "${google_compute_network.www_network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}

resource "google_compute_address" "public_ip" {
  count = "${var.servers_number}"

  name         = "www-server-ip-${count.index}"
  address_type = "EXTERNAL"
}

resource "google_compute_instance" "server" {
  count = "${var.servers_number}"

  name         = "www-server-${count.index}"
  machine_type = "${var.main_server_type}"
  zone         = "europe-west4-a"

  boot_disk {
    initialize_params {
      image = "list5-www"
    }
  }

  network_interface {
    network = "${google_compute_network.www_network.name}"

    access_config {
      nat_ip = "${element(google_compute_address.public_ip.*.address, count.index)}"
    }
  }
}

output "server_public_ips" {
  value = "${google_compute_address.public_ip.*.address}"
}

output "server_private_ips" {
  value = "${google_compute_instance.server.network_interface.0.network_ip}"
}

