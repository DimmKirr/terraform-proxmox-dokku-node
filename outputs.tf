output "ipv4_address" {
  value =  [
    for addr in proxmox_virtual_environment_vm.this.ipv4_addresses : addr[0]
    if addr[0] != "127.0.0.1"
  ][0]
}

output "username" {
  value = "root"
}

output "allowed_ips" {
  value = var.allowed_ips
}

