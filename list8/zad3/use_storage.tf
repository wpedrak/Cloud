provider "google" {
  project = "cloud2018-list2"
  region = "europe-west4"
}

data "google_project" "project" {}

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

# resource "google_project_iam_binding" "pubsub" {
#   role    = ""

#   members = [
#     "serviceAccount:${google_service_account.zad8-3.email}",
#   ]
# }

resource "google_pubsub_topic" "task-topic" {
  name = "topic-8-3"
}

resource "google_pubsub_subscription" "task-sub" {
  name  = "subscription-8-3"
  topic = "${google_pubsub_topic.task-topic.name}"

  ack_deadline_seconds = 300
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

  metadata_startup_script = "echo ${data.google_project.project.project_id} > /home/wojciechpedrak/PROJECT_ID; echo ${google_storage_bucket.result-holder.name} > /home/wojciechpedrak/BUCKET_NAME; echo ${google_pubsub_subscription.task-sub.name} > /home/wojciechpedrak/SUBSCRIPTION_NAME"

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