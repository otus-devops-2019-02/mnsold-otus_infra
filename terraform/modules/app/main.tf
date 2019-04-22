resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  # определение загрузочного диска 
  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
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
    # юнит systemd
    source      = "${path.module}/files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    # формирование конфигурационнго файла из шаблона
    inline = [
      "echo ${data.template_file.puma_env.rendered} > /tmp/puma_env.sh",
      "chmod a+x /tmp/puma_env.sh; /tmp/puma_env.sh",
    ]
  }

  provisioner "remote-exec" {
    # развертывание
    script = "${path.module}/files/deploy.sh"
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

resource "google_compute_address" "app_ip" {
  #IP для инстанса с приложением в виде внешнего ресурса
  name = "reddit-app-ip"
}

data "template_file" "puma_env" {
  #шаблон для создания конфигурации puma.service
  template = "${file("${path.module}/files/puma_env.tmpl.sh")}"

  vars {
    database_url = "${var.database_url}"
  }
}
