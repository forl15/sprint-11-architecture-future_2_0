folder_id = "YOUR_YANDEX_CLOUD_FOLDER_ID"

zone        = "ru-central1-a"
environment = "dev"

vm_user = "ubuntu"

ssh_public_key_path = "~/.ssh/id_ed25519.pub"

# Заменить на реальный внешний IP администратора
admin_cidr = "203.0.113.10/32"

public_subnet_cidr  = "192.168.10.0/24"
private_subnet_cidr = "192.168.20.0/24"

image_family = "ubuntu-2204-lts"

bastion_disk_size       = 20
platform_boot_disk_size = 30
platform_data_disk_size = 100
