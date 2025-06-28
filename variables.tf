variable "name" {}
variable "root_domain" {}
variable "target_node" {
  default = "pve"
}

variable "vm_storage" {
  default = "local-lvm"
}

variable "iso_storage" {
  default = "local"
}

variable "vm_id" {
  default = null
}

variable "disk_size" {
  type = number
  default = "50"
}

variable "dokku_version" {
  type = string
  default = "0.34.7"
}

variable "mac_address" {
  type = string
}

variable "ssh_public_key" {
  type = string
  description = "SSH public key contents"
}

variable "allowed_ips" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "manage_cloudflare" {
  type = bool
  description = "Enable Cloudflare DNS record management"
  default = true
}
