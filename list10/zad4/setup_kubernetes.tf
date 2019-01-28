provider "google" {
  project = "cloud2018-list2"
  region  = "europe-west4"
}

resource "google_container_cluster" "cluster" {
  name               = "cluster"
  zone               = "europe-west4-a"
  initial_node_count = 1

  node_config {
    machine_type = "n1-highcpu-2"
    disk_size_gb = 10
    image_type   = "COS"
  }

  node_version       = "1.11.6-gke.3"
  min_master_version = "1.11.6-gke.3"
}

resource "google_container_node_pool" "np-autoscale" {
  name       = "np-autoscale"
  zone       = "europe-west4-a"
  cluster    = "${google_container_cluster.cluster.name}"

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }
}