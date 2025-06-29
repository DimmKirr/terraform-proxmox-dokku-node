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
