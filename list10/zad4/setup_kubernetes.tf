provider "google" {
  project = "cloud2018-list2"
  region  = "europe-west4"
}

resource "google_container_cluster" "cluster" {
  name               = "cluster"
  zone               = "europe-west4-a"
  initial_node_count = 3

  node_config {
    machine_type = "n1-highcpu-2"
    disk_size_gb = 10
    image_type   = "COS"
  }

  node_version       = "1.11.6-gke.3"
  min_master_version = "1.11.6-gke.3"
}