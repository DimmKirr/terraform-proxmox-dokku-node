data "cloudflare_zone" "this" {
  filter = {
    name = var.root_domain
  }
}

data "cloudflare_ip_ranges" "this" {
  networks = "networks"
}

# Tunnel token for connector authentication
data "cloudflare_zero_trust_tunnel_cloudflared_token" "this" {
  count      = var.cloudflare_tunnel_enabled ? 1 : 0
  account_id = var.cloudflare_account_id
  tunnel_id  = local.tunnel_id
}
