provider "google" {
  project = "cloud2018-list2"
  region  = "europe-west4"
}

variable "region_name" {
  description = "Name of region to launch instances in."
  default     = "europe-north1"
}

variable "server_type" {
  description = "Server type to use."
  default     = "f1-micro"
}

locals {
  zone = "${var.region_name}-a"
}

data "google_project" "project" {}

resource "google_service_account" "zad8-3" {
  account_id   = "zad8-3"
  display_name = "zad8-3"
}

resource "google_project_iam_binding" "storage-rw" {
  role = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.zad8-3.email}",
  ]
}

resource "google_project_iam_binding" "pubsub" {
  role = "roles/pubsub.admin"

  members = [
    "serviceAccount:${google_service_account.zad8-3.email}",
  ]
}

resource "google_pubsub_topic" "task-topic" {
  name = "topic-8-3"
}

resource "google_pubsub_subscription" "task-sub" {
  name  = "subscription-8-3"
  topic = "${google_pubsub_topic.task-topic.name}"

  ack_deadline_seconds = 120
}

# resource "google_compute_instance" "server" {
#   name         = "test"
#   machine_type = "f1-micro"
#   zone         = "europe-west4-a"
#   tags         = ["server"]

#   boot_disk {
#     initialize_params {
#       image = "python-for-8-3"
#     }
#   }

#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral IP
#     }
#   }

#   metadata_startup_script = "echo ${data.google_project.project.project_id} > /home/wojciechpedrak/PROJECT_ID; echo ${google_storage_bucket.result-holder.name} > /home/wojciechpedrak/BUCKET_NAME; echo ${google_pubsub_subscription.task-sub.name} > /home/wojciechpedrak/SUBSCRIPTION_NAME; cd /home/wojciechpedrak/; ./task.py > testing.out 2> testing.err"

#   service_account {
#     email  = "${google_service_account.zad8-3.email}"
#     scopes = ["storage-rw", "pubsub"]
#   }
# }

data "google_compute_image" "template-image" {
  name    = "python-for-8-3"
  project = "cloud2018-list2"
}

resource "google_compute_instance_template" "instance-template" {
  name_prefix  = "instance-template-"
  machine_type = "${var.server_type}"
  region       = "${var.region_name}"

  # tags = ["http-server"]

  // Create a new boot disk from an image
  disk {
    source_image = "${data.google_compute_image.template-image.name}"
    auto_delete  = true
    boot         = true
  }
  metadata_startup_script = "echo ${data.google_project.project.project_id} > /home/wojciechpedrak/PROJECT_ID; echo ${google_storage_bucket.result-holder.name} > /home/wojciechpedrak/BUCKET_NAME; echo ${google_pubsub_subscription.task-sub.name} > /home/wojciechpedrak/SUBSCRIPTION_NAME; cd /home/wojciechpedrak/; ./task.py > testing.out 2> testing.err; ./abc.py > abc.out 2> abc.err"
  service_account {
    email  = "${google_service_account.zad8-3.email}"
    scopes = ["storage-rw", "pubsub"]
  }
  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance_group_manager" "managed-group" {
  name = "managed-group"
  base_instance_name = "python-prime"
  instance_template = "${google_compute_instance_template.instance-template.self_link}"

  # update_strategy    = "REPLACE"
  zone              = "${local.zone}"
}

resource "google_compute_autoscaler" "autoscaler-for-queue" {
  name   = "autoscaler-for-queue"
  zone   = "${local.zone}"
  target = "${google_compute_instance_group_manager.managed-group.self_link}"

  autoscaling_policy = {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 30

    cpu_utilization {
      target = 0.8
    }

    # non implemented in provider (even beta):
    # https://cloud.google.com/compute/docs/autoscaler/scaling-stackdriver-monitoring-metrics

    # metric {
    #   name = "pubsub.googleapis.com/subscription/num_undelivered_messages"
    #   target = 0
    #   type = "GUAGE"
    # }
  }
}

resource "google_storage_bucket" "result-holder" {
  name          = "result-holder"
  location      = "EU"
  force_destroy = true
}
