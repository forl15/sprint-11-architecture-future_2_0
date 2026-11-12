folder_id = "b1gu6m3h6259qvtimuei"

zone        = "ru-central1-a"
environment = "dev"

vm_user = "ubuntu"

ssh_public_key_path = "~/.ssh/id_ed25519.pub"

admin_cidr = "5.3.199.162/32"

public_subnet_cidr  = "192.168.10.0/24"
private_subnet_cidr = "192.168.20.0/24"

image_family = "ubuntu-2204-lts"

bastion_disk_size       = 10
platform_boot_disk_size = 10
platform_data_disk_size = 10
