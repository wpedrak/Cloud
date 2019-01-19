provider "google" {
  project = "cloud2018-list2"
  region  = "europe-west4"
}

resource "google_sql_database_instance" "notes-db" {
  name             = "notes-db4"
  database_version = "POSTGRES_9_6"
  region           = "europe-west4"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      private_network = "projects/cloud2018-list2/global/networks/default"
    }
  }
}

resource "google_sql_user" "db-user" {
  name     = "wpedrak"
  instance = "${google_sql_database_instance.notes-db.name}"
  password = "12345"
}

resource "google_sql_database" "notes" {
  name     = "notes"
  instance = "${google_sql_database_instance.notes-db.name}"
}

output "db_ip" {
  value = "${google_sql_database_instance.notes-db.ip_address.0.ip_address}"
}
