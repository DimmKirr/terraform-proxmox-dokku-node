# terraform-proxmox-dokku-node

[![Terraform Version](https://img.shields.io/badge/Terraform-%3E%3D1.0.0-blue.svg)](https://www.terraform.io/)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-%3E%3D1.0.0-1aaf5d.svg)](https://opentofu.org/)
[![terraform-docs](https://img.shields.io/badge/docs-terraform--docs-0266d6)](https://terraform-docs.io/)
[![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

A Terraform module to provision and manage a Dokku node on Proxmox with optional Cloudflare DNS integration.

## Features
- Deploys a Dokku VM on Proxmox
- Supports Cloudflare DNS automation
- Customizable VM parameters (disk size, network, etc.)
- SSH key provisioning
- Flexible configuration for advanced use cases

## Usage

```hcl
module "dokku_node" {
  source           = "dimmkirr/dokku-proxmox/terraform"
  version          = "~> 0.1"
  name             = "dokku-app"
  root_domain      = "example.com"
  mac_address      = "AA:BB:CC:DD:EE:FF"
  ssh_public_key   = file("~/.ssh/id_rsa.pub")
}
```

> **Note:** This module currently provisions only Debian 12 VMs.

For a complete example, see [`examples/complete`](./examples/complete/).

## Requirements
- [Terraform](https://www.terraform.io/downloads.html) or [OpenTofu](https://opentofu.org/download/)
- Proxmox access
- Cloudflare API token with the following permissions:

### Cloudflare API Token Permissions

> **Note:** These permissions are known to work. They can likely be refined to Edit/Read instead of all Edit for tighter security.

**All accounts:**
- DNS Settings: Edit
- Cloudflare One Connector: cloudflared: Edit
- Cloudflare Pages: Edit
- Transform Rules: Edit
- Account Rulesets: Edit
- Cloudflare Tunnel: Edit
- Rule Policies: Edit
- Zero Trust: Edit
- Account Settings: Edit

**All zones:**
- Zone Settings: Edit
- SSL and Certificates: Edit
- Page Rules: Edit
- Firewall Services: Edit
- DNS: Edit

## Getting Started
1. Clone this repo or use as a module source.
2. Configure your variables as needed.
3. Run `terraform init` (or `tofu init`), `terraform plan`, and `terraform apply`.
4. Documentation is auto-injected below.

## Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 5.6.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >= 0.50.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.6.0 |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 0.87.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_ruleset.allow_only_allowed_ips](https://registry.terraform.io/providers/cloudflare/cloudflare/5.6.0/docs/resources/ruleset) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.6.0/docs/resources/zero_trust_tunnel_cloudflared) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared_config.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.6.0/docs/resources/zero_trust_tunnel_cloudflared_config) | resource |
| [proxmox_virtual_environment_download_file.image](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_download_file) | resource |
| [proxmox_virtual_environment_file.cloud_config](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_file.dokku_wait_hook](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_vm.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |
| [random_password.tunnel_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [cloudflare_ip_ranges.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.6.0/docs/data-sources/ip_ranges) | data source |
| [cloudflare_zero_trust_tunnel_cloudflared.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.6.0/docs/data-sources/zero_trust_tunnel_cloudflared) | data source |
| [cloudflare_zero_trust_tunnel_cloudflared_token.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.6.0/docs/data-sources/zero_trust_tunnel_cloudflared_token) | data source |
| [cloudflare_zone.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.6.0/docs/data-sources/zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of allowed IPs for Cloudflare rules. | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_cloudflare_account_id"></a> [cloudflare\_account\_id](#input\_cloudflare\_account\_id) | Cloudflare account ID for tunnel management | `string` | `""` | no |
| <a name="input_cloudflare_tunnel_enabled"></a> [cloudflare\_tunnel\_enabled](#input\_cloudflare\_tunnel\_enabled) | Enable Cloudflare Tunnel integration | `bool` | `true` | no |
| <a name="input_cloudflare_tunnel_name"></a> [cloudflare\_tunnel\_name](#input\_cloudflare\_tunnel\_name) | Name of the Cloudflare tunnel (created or referenced). Defaults to var.name if empty. | `string` | `""` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | VM disk size in GB. | `number` | `"50"` | no |
| <a name="input_dokku_version"></a> [dokku\_version](#input\_dokku\_version) | Dokku version to install. | `string` | `"0.34.7"` | no |
| <a name="input_enable_monorepo_hook"></a> [enable\_monorepo\_hook](#input\_enable\_monorepo\_hook) | Enable custom post-extract hook to support Dockerfile in build-dir for monorepos. | `bool` | `false` | no |
| <a name="input_image"></a> [image](#input\_image) | n/a | `map(string)` | <pre>{<br/>  "checksum": "c651c2f3fd1ee342f225724959a86a97ad804027c3f057e03189455d093d07a006390929a22df0f95a5269291badc619964bde8bf9e2a33b6f3a01f492895068",<br/>  "checksum_algorithm": "sha512",<br/>  "file_name": "debian-12-generic-amd64.img",<br/>  "url": "https://cloud.debian.org/images/cloud/bookworm/20250703-2162/debian-12-generic-amd64-20250703-2162.qcow2"<br/>}</pre> | no |
| <a name="input_install_plugins"></a> [install\_plugins](#input\_install\_plugins) | List of Dokku plugins to install. | `list(string)` | `[]` | no |
| <a name="input_iso_storage"></a> [iso\_storage](#input\_iso\_storage) | Proxmox storage backend for ISO/snippet files. | `string` | `"local"` | no |
| <a name="input_mac_address"></a> [mac\_address](#input\_mac\_address) | MAC address for the VM network interface. | `string` | n/a | yes |
| <a name="input_manage_cloudflare"></a> [manage\_cloudflare](#input\_manage\_cloudflare) | Enable Cloudflare DNS record management. | `bool` | `true` | no |
| <a name="input_manage_cloudflare_tunnel"></a> [manage\_cloudflare\_tunnel](#input\_manage\_cloudflare\_tunnel) | Create a new Cloudflare tunnel (true) or reference existing (false) | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Dokku VM and related resources. | `any` | n/a | yes |
| <a name="input_root_domain"></a> [root\_domain](#input\_root\_domain) | Root domain for DNS records (e.g., example.com). | `any` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key contents. | `string` | n/a | yes |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | Proxmox node name where the VM will be created. | `string` | `"pve"` | no |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id) | Optional static VM ID. If not set, Proxmox auto-assigns. | `any` | `null` | no |
| <a name="input_vm_storage"></a> [vm\_storage](#input\_vm\_storage) | Proxmox storage backend for the VM disk. | `string` | `"local-lvm"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_allowed_ips"></a> [allowed\_ips](#output\_allowed\_ips) | n/a |
| <a name="output_cloudflare_tunnel_cname"></a> [cloudflare\_tunnel\_cname](#output\_cloudflare\_tunnel\_cname) | CNAME target for DNS records pointing to this tunnel |
| <a name="output_cloudflare_tunnel_id"></a> [cloudflare\_tunnel\_id](#output\_cloudflare\_tunnel\_id) | Cloudflare tunnel ID (connector ID) |
| <a name="output_cloudflare_tunnel_name"></a> [cloudflare\_tunnel\_name](#output\_cloudflare\_tunnel\_name) | Cloudflare tunnel name |
| <a name="output_ipv4_address"></a> [ipv4\_address](#output\_ipv4\_address) | n/a |
| <a name="output_username"></a> [username](#output\_username) | n/a |
<!-- END_TF_DOCS -->

## Contributing
Contributions, issues, and feature requests are welcome! Please open an issue or submit a pull request.

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
