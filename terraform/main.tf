terraform {
  # Версия terraform
  required_version = ">=0.11,<0.12"
}

provider "google" {
  # Версия провайдера
  version = "2.0.0"

  # ID проекта
  project = "${var.project}"

  region = "${var.region}"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app${count.index}"
  machine_type = "g1-small"

  zone = "${var.zone}"
  tags = ["reddit-app"]
  count = "${var.reddit_pool_nodes}"

  # определение загрузочного диска 
  boot_disk {
    initialize_params {
      #image = "famaly_image or image"
      image = "${var.disk_image}"
    }
  }

  # определение сетевого интерфейса 
  network_interface {
    # сеть, к которой присоединить данный интерфейс 
    network = "default"

    # использовать ephemeral IP для доступа из Интернет 
    access_config {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    user  = "appuser"
    agent = false

    # путь до приватного ключа 
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}

resource "google_compute_project_metadata" "default" {
  # добавление ssh в проект, проект определен на уровне провайдера
  metadata {
    # путь до публичного ключа
    ssh-keys = "appuser1:${file(var.public_key_path)} appuser2:${file(var.public_key_path)}"
  }
}

resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  network = "default"
  description = "Terraform allow SSH from anywhere"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "app_ip" { 
  #IP для инстанса с приложением в виде внешнего ресурса
  name = "reddit-app-ip" 
}
