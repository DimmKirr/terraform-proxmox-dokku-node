module "dokku_proxmox" {
  source            = "../../terraform/dokku-proxmox"
  name              = "dokku-app"
  root_domain       = "example.com"
  target_node       = "pve"
  vm_storage        = "local-lvm"
  iso_storage       = "local"
  vm_id             = 123
  disk_size         = "50"
  dokku_version     = "0.34.7"
  mac_address       = "AA:BB:CC:DD:EE:FF"
  ssh_public_key    = file("~/.ssh/id_rsa.pub")
  allowed_ips       = ["203.0.113.1/32"]
  enabled           = true
  manage_cloudflare = true
}
