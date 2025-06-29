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
- Cloudflare API token

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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.6.0 |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >= 0.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_ruleset.allow_only_allowed_ips](https://registry.terraform.io/providers/cloudflare/cloudflare/5.6.0/docs/resources/ruleset) | resource |
| [proxmox_virtual_environment_download_file.image](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_download_file) | resource |
| [proxmox_virtual_environment_file.cloud_config](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_file.dokku_wait_hook](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_vm.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |
| [cloudflare_ip_ranges.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.6.0/docs/data-sources/ip_ranges) | data source |
| [cloudflare_zone.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.6.0/docs/data-sources/zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | n/a | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | n/a | `number` | `"50"` | no |
| <a name="input_dokku_version"></a> [dokku\_version](#input\_dokku\_version) | n/a | `string` | `"0.34.7"` | no |
| <a name="input_iso_storage"></a> [iso\_storage](#input\_iso\_storage) | n/a | `string` | `"local"` | no |
| <a name="input_mac_address"></a> [mac\_address](#input\_mac\_address) | n/a | `string` | n/a | yes |
| <a name="input_manage_cloudflare"></a> [manage\_cloudflare](#input\_manage\_cloudflare) | Enable Cloudflare DNS record management | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `any` | n/a | yes |
| <a name="input_root_domain"></a> [root\_domain](#input\_root\_domain) | n/a | `any` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key contents | `string` | n/a | yes |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | n/a | `string` | `"pve"` | no |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id) | n/a | `any` | `null` | no |
| <a name="input_vm_storage"></a> [vm\_storage](#input\_vm\_storage) | n/a | `string` | `"local-lvm"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_allowed_ips"></a> [allowed\_ips](#output\_allowed\_ips) | n/a |
| <a name="output_ipv4_address"></a> [ipv4\_address](#output\_ipv4\_address) | n/a |
| <a name="output_username"></a> [username](#output\_username) | n/a |
<!-- END_TF_DOCS -->

## Contributing
Contributions, issues, and feature requests are welcome! Please open an issue or submit a pull request.

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
