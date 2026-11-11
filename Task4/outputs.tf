output "network_id" {
  description = "VPC network ID"
  value       = yandex_vpc_network.main.id
}

output "public_subnet_id" {
  value = yandex_vpc_subnet.public.id
}

output "private_subnet_id" {
  value = yandex_vpc_subnet.private.id
}

output "bastion_public_ip" {
  description = "Public IP of Bastion VM"
  value       = yandex_compute_instance.bastion
  .network_interface[0].nat_ip_address
}

output "bastion_private_ip" {
  value = yandex_compute_instance.bastion
  .network_interface[0].ip_address
}

output "platform_private_ip" {
  description = "Private IP of data platform"
  value = yandex_compute_instance.platform
  .network_interface[0].ip_address
}

output "platform_instance_id" {
  value = yandex_compute_instance.platform.id
}

output "platform_data_disk_id" {
  value = yandex_compute_disk.platform_data.id
}

output "ssh_command" {
  description = "SSH connection to Bastion"
  value = "ssh ${var.vm_user}@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}"
}
