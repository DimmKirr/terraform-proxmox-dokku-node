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
    file_name          = "debian-12-generic-amd64.img"
    url                = "https://cloud.debian.org/images/cloud/bookworm/20250703-2162/debian-12-generic-amd64-20250703-2162.qcow2"
    checksum_algorithm = "sha512"
    checksum           = "c651c2f3fd1ee342f225724959a86a97ad804027c3f057e03189455d093d07a006390929a22df0f95a5269291badc619964bde8bf9e2a33b6f3a01f492895068"
  }
}

variable "install_plugins" {
  description = "List of Dokku plugins to install."
  type        = list(string)
  default     = []
}

variable "enable_monorepo_hook" {
  description = "Enable custom post-extract hook to support Dockerfile in build-dir for monorepos."
  type        = bool
  default     = false
}

variable "cloudflare_tunnel_enabled" {
  description = "Enable Cloudflare Tunnel integration"
  type        = bool
  default     = true
}

variable "manage_cloudflare_tunnel" {
  description = "Create a new Cloudflare tunnel (true) or reference existing (false)"
  type        = bool
  default     = true
}

variable "cloudflare_tunnel_name" {
  description = "Name of the Cloudflare tunnel (created or referenced). Defaults to var.name if empty."
  type        = string
  default     = ""
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID for tunnel management. Leave empty to auto-detect from API token (works if token has access to only one account)."
  type        = string
  default     = ""
  sensitive   = true
}

variable "mounts" {
  description = "List of filesystem mounts to add to /etc/fstab. Each mount requires device, path, fstype, and options. Dump and pass are optional (default to 0)."
  type = list(object({
    device  = string
    path    = string
    fstype  = string
    options = string
    dump    = optional(string, "0")
    pass    = optional(string, "0")
  }))
  default = []
}
