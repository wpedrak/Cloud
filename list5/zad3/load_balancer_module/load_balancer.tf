variable "server_type" {
  description = "Server type to use for the main application server."
  default     = "f1-micro"
}

variable "image_name" {
  description = "Name of image to create instances from"
}

variable "destination_ips" {
  type        = "list"
  description = "List of ip addreses that will eventually get request from load-balancer"
}

variable "network" {
  description = "Network to lauch load-balancer in."
}

variable "region" {
  description = "Region"
  default = "europe-west4"
}

# not sure why
resource "google_compute_subnetwork" "load-balancer_subnetwork" {
  name          = "load-balancer-subnetwork"
  ip_cidr_range = "10.0.1.0/24"
  region        = "${var.region}"
  network       = "${var.network}"
}

resource "google_compute_firewall" "load-balancer_firewall" {
  name    = "load-balancer-firewall"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}

resource "google_compute_address" "public_ip" {
  name         = "load-balancer"
  address_type = "EXTERNAL"
  region       = "${var.region}"
}

resource "google_compute_instance" "load_balancer" {
  name         = "load-balancer"
  machine_type = "${var.server_type}"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "${var.image_name}"
    }
  }

  metadata_startup_script = "echo >> /etc/haproxy/haproxy.cfg; IFS=' ' read -r -a array <<< \"${join(" ", var.destination_ips)}\"; for element in \"$${array[@]}\"; do echo \"   server $element $element:80 check\" >> /etc/haproxy/haproxy.cfg; done; /etc/init.d/haproxy restart" 
  # metadata_startup_script = "IFS=' ' read -r -a array <<< \"ala ma kota chyba\"; for element in \"$${array[@]}\"; do echo \"   server $element $element:80 check\" >> /etc/haproxy/haproxy.cfg; done" 

  network_interface {
    subnetwork = "${google_compute_subnetwork.load-balancer_subnetwork.self_link}"

    access_config {
      nat_ip = "${google_compute_address.public_ip.address}"
    }
  }
}

output "public_ip" {
  value = "${google_compute_address.public_ip.address}"
}