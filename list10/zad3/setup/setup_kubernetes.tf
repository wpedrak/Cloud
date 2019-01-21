resource "google_container_cluster" "cluster" {
  name               = "cluster"
  zone               = "europe-west4-a"
  initial_node_count = 4

  network = "projects/cloud2018-list2/global/networks/default"

  node_config {
    machine_type = "n1-highcpu-2"
    disk_size_gb = 10
    # image_type   = "COS"
  }

  node_version       = "1.10.9-gke.5"
  min_master_version = "1.10.9-gke.5"
}

# provider "kubernetes" {
#   host       = "https://${google_container_cluster.cluster.endpoint}"
#   client_key = "${base64decode(google_container_cluster.cluster.master_auth.0.client_key)}"

#   client_certificate     = "${base64decode(google_container_cluster.cluster.master_auth.0.client_certificate)}"
#   cluster_ca_certificate = "${base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)}"
# }

# resource "kubernetes_deployment" "front" {
#   metadata {
#     name = "front-deployment"

#     labels {
#       app = "front-deployment"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels {
#         app = "front"
#       }
#     }

#     template {
#       metadata {
#         labels {
#           app = "front"
#         }
#       }

#       spec {
#         container {
#           image = "wpedrak/front"
#           name  = "front"

#           env = [{
#             name  = "WRITER_IP"
#             value = "writer.local"
#           },
#             {
#               name  = "READER_IP"
#               value = "reader.local"
#             },
#           ]

#           port {
#             container_port = 3000
#           }
#         }

#         # resources {
#         #   limits {
#         #     cpu    = "0.5"
#         #     memory = "128Mi"
#         #   }

#         #   requests {
#         #     cpu    = "250m"
#         #     memory = "64Mi"
#         #   }
#         # }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "front" {
#   metadata {
#     name = "front-service"
#   }

#   spec {
#     selector {
#       app = "front"
#     }

#     port {
#       port        = 80
#       # node_port   = 3000
#       target_port = 3000
#     }

#     type = "LoadBalancer"
#   }
# }

# resource "kubernetes_deployment" "back" {
#   metadata {
#     name = "back-deployment"

#     labels {
#       app = "back-deployment"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels {
#         app = "back"
#       }
#     }

#     template {
#       metadata {
#         labels {
#           app = "back"
#         }
#       }

#       spec {
#         container {
#           image = "wpedrak/writer"
#           name  = "writer"

#           env = [{
#             name  = "DB_IP"
#             value = "${google_sql_database_instance.notes-db.ip_address.0.ip_address}"
#           },
#             {
#               name  = "DB_PASSWORD"
#               value = "${google_sql_user.db-user.password}"
#             },
#           ]

#           port {
#             container_port = 4000
#           }
#         }

#         container {
#           image = "wpedrak/reader"
#           name  = "reader"

#           env = [{
#             name  = "DB_IP"
#             value = "${google_sql_database_instance.notes-db.ip_address.0.ip_address}"
#           },
#             {
#               name  = "DB_PASSWORD"
#               value = "${google_sql_user.db-user.password}"
#             },
#           ]

#           port {
#             container_port = 5000
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "back" {
#   metadata {
#     name = "back-service"
#   }

#   spec {
#     selector {
#       app = "back"
#     }

#     port {
#       name = "for-writer"
#       port        = 4000
#       target_port = 4000
#     }

#     port {
#       name = "for-reader"
#       port        = 5000
#       target_port = 5000
#     }

#     type = "ClusterIP"
#   }
# }

# output "lb_ip" {
#   value = "${kubernetes_service.front.load_balancer_ingress.0.ip}"
# }
