resource "cloudflare_ruleset" "allow_only_allowed_ips" {
  count       = var.manage_cloudflare ? 1 : 0
  kind        = "zone"
  name        = "Allow only allowed IPs, block all others"
  phase       = "http_request_firewall_custom"
  zone_id     = data.cloudflare_zone.this.zone_id
  description = "Block all except allowed IPs"
  rules = [{
    action      = "block"
    description = "Block when the IP address is not in allowed_ips"
    enabled     = true
    expression  = "not (ip.src in {${join(" ", var.allowed_ips)}})"
  }]
}

# Locals for unified tunnel access (managed vs referenced)
locals {
  # Auto-detect account_id from API token if not explicitly provided
  cloudflare_account_id = var.cloudflare_account_id != "" ? var.cloudflare_account_id : (
    length(data.cloudflare_accounts.this) > 0 && length(data.cloudflare_accounts.this[0].result) > 0
    ? data.cloudflare_accounts.this[0].result[0].id
    : ""
  )

  tunnel_id = var.cloudflare_tunnel_enabled ? (
    var.manage_cloudflare_tunnel ? cloudflare_zero_trust_tunnel_cloudflared.this[0].id : data.cloudflare_zero_trust_tunnel_cloudflared.this[0].id
  ) : ""

  tunnel_name = var.cloudflare_tunnel_enabled ? (
    var.manage_cloudflare_tunnel ? cloudflare_zero_trust_tunnel_cloudflared.this[0].name : data.cloudflare_zero_trust_tunnel_cloudflared.this[0].name
  ) : ""

  effective_tunnel_name = var.cloudflare_tunnel_name != "" ? var.cloudflare_tunnel_name : var.name
}

# Random secret for managed tunnel
resource "random_password" "tunnel_secret" {
  count   = var.cloudflare_tunnel_enabled && var.manage_cloudflare_tunnel ? 1 : 0
  length  = 64
  special = false
}

# Managed tunnel (create new)
resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  count         = var.cloudflare_tunnel_enabled && var.manage_cloudflare_tunnel ? 1 : 0
  account_id    = local.cloudflare_account_id
  name          = local.effective_tunnel_name
  tunnel_secret = base64encode(random_password.tunnel_secret[0].result)

  lifecycle {
    precondition {
      condition     = local.cloudflare_account_id != ""
      error_message = <<-EOT
        Cloudflare account ID could not be auto-detected from API token.

        This usually means your API token doesn't have account-level permissions.

        Please set var.cloudflare_account_id explicitly:
        - Find your account ID in Cloudflare dashboard → Account Settings → Account ID
        - Or grant your API token "Account" permissions
      EOT
    }
  }
}

# Referenced tunnel (use existing)
data "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  count      = var.cloudflare_tunnel_enabled && !var.manage_cloudflare_tunnel ? 1 : 0
  account_id = local.cloudflare_account_id
  filter = {
    name = local.effective_tunnel_name
  }
}

# Tunnel configuration with ingress rules
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  count      = var.cloudflare_tunnel_enabled ? 1 : 0
  account_id = local.cloudflare_account_id
  tunnel_id  = local.tunnel_id

  config = {
    ingress = [
      # Root domain ingress
      {
        hostname = var.root_domain
        service  = "http://localhost:80"
      },
      # Wildcard subdomain ingress
      {
        hostname = "*.${var.root_domain}"
        service  = "http://localhost:80"
      },
      # Catch-all (required by Cloudflare)
      {
        service = "http_status:404"
      }
    ]
  }
}
