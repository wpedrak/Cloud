provider "google" {
  project = "cloud2018-list2"
  region  = "europe-west4"
}

resource "google_sql_database_instance" "notes-db" {
  name = "notes-db"
  database_version = "POSTGRES_9_6"
  region = "europe-west4"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "db-user" {
  name     = "wpedrak"
  instance = "${google_sql_database_instance.notes-db.name}"
  password = "12345"
}

resource "google_sql_database" "notes" {
  name      = "notes"
  instance  = "${google_sql_database_instance.notes-db.name}"
}

output "db_link" {
  value = "${google_sql_database_instance.notes-db.connection_name}"
}
