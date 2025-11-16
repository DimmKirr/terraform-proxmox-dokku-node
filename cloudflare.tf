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
