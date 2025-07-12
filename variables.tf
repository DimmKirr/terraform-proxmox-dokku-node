variable "name" {
  description = "Name of the Dokku VM and related resources."
}

variable "root_domain" {
  description = "Root domain for DNS records (e.g., example.com)."
}

variable "target_node" {
  description = "Proxmox node name where the VM will be created."
  default     = "pve"
}

variable "vm_storage" {
  description = "Proxmox storage backend for the VM disk."
  default     = "local-lvm"
}

variable "iso_storage" {
  description = "Proxmox storage backend for ISO/snippet files."
  default     = "local"
}

variable "vm_id" {
  description = "Optional static VM ID. If not set, Proxmox auto-assigns."
  default     = null
}

variable "disk_size" {
  description = "VM disk size in GB."
  type        = number
  default     = "50"
}

variable "dokku_version" {
  description = "Dokku version to install."
  type        = string
  default     = "0.34.7"
}

variable "mac_address" {
  description = "MAC address for the VM network interface."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key contents."
  type        = string
}

variable "allowed_ips" {
  description = "List of allowed IPs for Cloudflare rules."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "manage_cloudflare" {
  description = "Enable Cloudflare DNS record management."
  type        = bool
  default     = true
}

variable "image" {
  type = map(string)
  default = {
    file_name = "debian-12-generic-amd64.img"
    url = "https://cloud.debian.org/images/cloud/bookworm/20250703-2162/debian-12-generic-amd64-20250703-2162.qcow2"
    checksum_algorithm = "sha512"
    checksum = "c651c2f3fd1ee342f225724959a86a97ad804027c3f057e03189455d093d07a006390929a22df0f95a5269291badc619964bde8bf9e2a33b6f3a01f492895068"
  }
}
