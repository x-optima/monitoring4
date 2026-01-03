#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
  
}

resource "yandex_compute_instance" "server" {
  name        = "server" #Имя ВМ в облачной консоли
  hostname    = "server" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 15
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.internet.id]
  }
}

resource "yandex_compute_instance" "client1" {
  name        = "client1" #Имя ВМ в облачной консоли
  hostname    = "client1" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 15
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.internet.id]
  }
}

resource "yandex_compute_instance" "client2" {
  name        = "client2" #Имя ВМ в облачной консоли
  hostname    = "client2" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 15
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.internet.id]
  }
}


resource "local_file" "inventory" {
  content  = <<-XYZ
  [servers]
  ${yandex_compute_instance.server.network_interface.0.nat_ip_address}

  [clients]
  ${yandex_compute_instance.client1.network_interface.0.nat_ip_address}
  ${yandex_compute_instance.client2.network_interface.0.nat_ip_address}

  [servers:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q yc-user@${yandex_compute_instance.server.network_interface.0.nat_ip_address}"'
 
  [clients:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q yc-user@${yandex_compute_instance.client1.network_interface.0.nat_ip_address}"'
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q yc-user@${yandex_compute_instance.client2.network_interface.0.nat_ip_address}"'
    
  XYZ
  filename = "./hosts.ini"
}