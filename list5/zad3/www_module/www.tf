variable "server_type" {
  description = "Server type to use for the main application server."
  default     = "f1-micro"
}

variable "servers_number" {
  description = "Number of servers to create."
  default     = 1
}

variable "image_name" {
  description = "Name of image to create instances from."
}

variable "network" {
  description = "Link to network to lauch instances in."
}

variable "region" {
  description = "Region"
  default = "europe-west4"
}

# not sure why
resource "google_compute_subnetwork" "www_subnetwork" {
  name          = "www-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region        = "${var.region}"
  network       = "${var.network}"
}

resource "google_compute_firewall" "www_firewall" {
  name    = "www-firewall"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "server" {
  count = "${var.servers_number}"

  name         = "www-server-${count.index}"
  machine_type = "${var.server_type}"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "${var.image_name}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.www_subnetwork.self_link}"
  }
}

output "server_private_ips" {
  value = "${google_compute_instance.server.network_interface.0.network_ip}"
}

