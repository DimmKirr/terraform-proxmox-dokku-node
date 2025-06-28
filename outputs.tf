output "ipv4_address" {
  value = local.non_local_ips[0]
}

output "username" {
  value = "root"
}

output "allowed_ips" {
  value = var.allowed_ips
}

locals {
  all_ips      = flatten(proxmox_virtual_environment_vm.this.ipv4_addresses)
  non_local_ips = [for ip in local.all_ips : ip if ip != "127.0.0.1"]
}

