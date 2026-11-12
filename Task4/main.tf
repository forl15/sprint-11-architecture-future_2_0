terraform {
  required_version = ">= 1.6.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.244.0"
    }
  }
}

provider "yandex" {
  folder_id = var.folder_id
  zone      = var.zone
}

locals {
  common_labels = {
    project     = "future20"
    environment = var.environment
    managed_by  = "terraform"
  }

  cloud_init = <<-EOF
    #cloud-config
    users:
      - name: ${var.vm_user}
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
          - ${trimspace(file(pathexpand(var.ssh_public_key_path)))}
    package_update: true
    timezone: Europe/Moscow
  EOF
}

# --------------------------------------------------
# NETWORK
# --------------------------------------------------

resource "yandex_vpc_network" "main" {
  name        = "future20-network"
  description = "Network for Future 2.0 data platform"
  labels      = local.common_labels
}

# --------------------------------------------------
# NAT GATEWAY
# --------------------------------------------------

resource "yandex_vpc_gateway" "nat" {
  name = "future20-nat-gateway"

  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private" {
  name       = "future20-private-route"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}

# --------------------------------------------------
# SUBNETS
# --------------------------------------------------

resource "yandex_vpc_subnet" "public" {
  name           = "future20-public-subnet"
  description    = "Public subnet for Bastion"
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.public_subnet_cidr]
}

resource "yandex_vpc_subnet" "private" {
  name           = "future20-private-subnet"
  description    = "Private subnet for data platform"
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.private_subnet_cidr]
  route_table_id = yandex_vpc_route_table.private.id
}

# --------------------------------------------------
# SECURITY GROUPS
# --------------------------------------------------

resource "yandex_vpc_security_group" "bastion" {
  name       = "future20-bastion-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "SSH from administrator"
    port           = 22
    v4_cidr_blocks = [var.admin_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Outbound traffic"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "platform" {
  name       = "future20-platform-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "SSH from Bastion subnet"
    port           = 22
    v4_cidr_blocks = [var.public_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Outbound traffic through NAT"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------------------------------------------
# OS IMAGE
# --------------------------------------------------

data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

# --------------------------------------------------
# BASTION VM
# --------------------------------------------------

resource "yandex_compute_disk" "bastion_boot" {
  name     = "future20-bastion-boot"
  type     = "network-hdd"
  zone     = var.zone
  size     = var.bastion_disk_size
  image_id = data.yandex_compute_image.ubuntu.id

  labels = local.common_labels
}

resource "yandex_compute_instance" "bastion" {
  name        = "future20-bastion"
  hostname    = "bastion"
  zone        = var.zone
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    disk_id = yandex_compute_disk.bastion_boot.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [
      yandex_vpc_security_group.bastion.id
    ]
  }

  metadata = {
    user-data = local.cloud_init
  }

  labels = local.common_labels
}

# --------------------------------------------------
# DATA PLATFORM VM
# --------------------------------------------------

resource "yandex_compute_disk" "platform_boot" {
  name     = "future20-platform-boot"
  type     = "network-ssd"
  zone     = var.zone
  size     = var.platform_boot_disk_size
  image_id = data.yandex_compute_image.ubuntu.id

  labels = local.common_labels
}

resource "yandex_compute_disk" "platform_data" {
  name = "future20-platform-data"
  type = "network-hdd"
  zone = var.zone
  size = var.platform_data_disk_size

  labels = local.common_labels
}

resource "yandex_compute_instance" "platform" {
  name                      = "future20-data-platform"
  hostname                  = "data-platform"
  zone                      = var.zone
  platform_id               = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 8
    core_fraction = 20
  }

  boot_disk {
    disk_id = yandex_compute_disk.platform_boot.id
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.platform_data.id
    device_name = "data"
    auto_delete = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
    security_group_ids = [
      yandex_vpc_security_group.platform.id
    ]
  }

  metadata = {
    user-data = local.cloud_init
  }

  labels = local.common_labels

  depends_on = [
    yandex_vpc_subnet.private
  ]
}
