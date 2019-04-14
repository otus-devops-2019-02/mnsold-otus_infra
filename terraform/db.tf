resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "g1-small"
  zone = "${var.zone}"
  tags = ["reddit-db"]
  # определение загрузочного диска 
  boot_disk {
    initialize_params {
      #image = "famaly_image or image"
      image = "${var.db_disk_image}"
    }
  }
  # определение сетевого интерфейса 
  network_interface {
    # сеть, к которой присоединить данный интерфейс 
    network = "default"
    # использовать ephemeral IP для доступа из Интернет 
    access_config {}
  }
  metadata {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_firewall" "firewall_mongo" {
  name = "allow-mongo-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
