variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vm_user" {
  description = "Linux VM user"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "admin_cidr" {
  description = "Administrator public IP in CIDR notation"
  type        = string

  validation {
    condition = can(cidrnetmask(var.admin_cidr))
    error_message = "admin_cidr must be a valid CIDR."
  }
}

variable "public_subnet_cidr" {
  type    = string
  default = "192.168.10.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "192.168.20.0/24"
}

variable "image_family" {
  description = "Ubuntu image family"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "bastion_disk_size" {
  type    = number
  default = 20
}

variable "platform_boot_disk_size" {
  type    = number
  default = 30
}

variable "platform_data_disk_size" {
  type    = number
  default = 100
}
