data "cloudflare_zone" "this" {
  filter = {
    name = var.root_domain
  }
}

data "cloudflare_ip_ranges" "this" {
  networks = "networks"
}

# Auto-detect Cloudflare account ID from API token if not explicitly provided
# Fetches ALL accounts the token has access to (no filters)
data "cloudflare_accounts" "this" {
  count = var.cloudflare_tunnel_enabled && var.cloudflare_account_id == "" ? 1 : 0
}

# Tunnel token for connector authentication
data "cloudflare_zero_trust_tunnel_cloudflared_token" "this" {
  count      = var.cloudflare_tunnel_enabled ? 1 : 0
  account_id = local.cloudflare_account_id
  tunnel_id  = local.tunnel_id
}
