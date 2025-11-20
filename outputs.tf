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
  all_ips       = flatten(proxmox_virtual_environment_vm.this.ipv4_addresses)
  non_local_ips = [for ip in local.all_ips : ip if ip != "127.0.0.1"]
}

# Cloudflare Tunnel outputs
output "cloudflare_tunnel_name" {
  description = "Cloudflare tunnel name"
  value       = var.cloudflare_tunnel_enabled ? local.tunnel_name : null
}

output "cloudflare_tunnel_id" {
  description = "Cloudflare tunnel ID (connector ID)"
  value       = var.cloudflare_tunnel_enabled ? local.tunnel_id : null
}

output "cloudflare_tunnel_cname" {
  description = "CNAME target for DNS records pointing to this tunnel"
  value       = var.cloudflare_tunnel_enabled ? "${local.tunnel_id}.cfargotunnel.com" : null
}

