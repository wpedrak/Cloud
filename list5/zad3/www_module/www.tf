variable "main_server_type" {
  description = "Server type to use for the main application server."
  default     = "g1-micro"
}

variable "servers_number" {
  description = "Number of servers to create"
  default     = 1
}

resource "google_compute_address" "public_ip" {
  count = "${var.servers_number}"
  
  name         = "server-ip-${count.index}"
  address_type = "EXTERNAL"
}