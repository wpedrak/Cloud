provider "google" {
  project = "cloud2018-list2"
  region = "europe-west4"
}

resource "google_service_account" "zad8-3" {
  account_id   = "zad8-3"
  display_name = "zad8-3"
}

resource "google_project_iam_binding" "storage-rw" {
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.zad8-3.email}",
  ]
}


resource "google_compute_instance" "server" {
  name         = "test"
  machine_type = "f1-micro"
  zone         = "europe-west4-a"
  tags         = ["server"]

  boot_disk {
    initialize_params {
      image = "python-for-8-3"
    }
  }

   network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    email = "${google_service_account.zad8-3.email}"
    scopes = ["storage-rw"]
  }
}


resource "google_storage_bucket" "result-holder" {
  name     = "result-holder"
  location = "EU"
  force_destroy = true
}