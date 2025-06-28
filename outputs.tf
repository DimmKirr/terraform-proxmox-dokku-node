output "ipv4_address" {
  value =  proxmox_virtual_environment_vm.this.ipv4_addresses[0][0]
}

output "username" {
  value = "root"
}

output "allowed_ips" {
  value = var.allowed_ips
}

