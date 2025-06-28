# dokku-proxmox Terraform Module

Provision a Debian-based VM with Dokku preinstalled on a Proxmox VE cluster, with optional Cloudflare IP restrictions.

## Features
- Provisions a VM on Proxmox VE with cloud-init
- Installs Dokku (customizable version)
- Configures SSH access
- Optionally restricts access via Cloudflare firewall rules
- Customizable VM specs (CPU, RAM, disk, network)

## Usage
```hcl
module "dokku_proxmox" {
  source           = "./terraform/dokku-proxmox"
  name             = "dokku-app"
  root_domain      = "example.com"
  target_node      = "pve"
  vm_storage       = "local-lvm"
  iso_storage      = "local"
  template_name    = "debian12"
  vm_id            = 0
  disk_size        = "50G"
  dokku_version    = "0.34.7"
  mac_address      = "AA:BB:CC:DD:EE:FF"
  ssh_public_key   = file("~/.ssh/id_rsa.pub")
  allowed_ips      = ["203.0.113.1/32"]
  enabled          = true
  manage_cloudflare = true
}
```

## Inputs
| Name             | Description                              | Type          | Default           |
|------------------|------------------------------------------|---------------|-------------------|
| name             | VM hostname                              | string        | -                 |
| root_domain      | Root DNS zone (Cloudflare)               | string        | -                 |
| target_node      | Proxmox node name                        | string        | "pve"             |
| vm_storage       | Proxmox storage for VM disk              | string        | "local-lvm"       |
| iso_storage      | Proxmox storage for cloud-init           | string        | "local"           |
| template_name    | Template name (for future use)           | string        | "debian12"        |
| vm_id            | Proxmox VM ID                            | number        | 0                 |
| disk_size        | Disk size                                | string        | "50G"             |
| dokku_version    | Dokku version to install                 | string        | "0.34.7"          |
| mac_address      | MAC address for VM                       | string        | -                 |
| ssh_public_key   | SSH public key for root                  | string        | -                 |
| allowed_ips      | List of allowed IPs (Cloudflare)         | list(string)  | ["0.0.0.0/0"]     |
| enabled          | Whether to create resources              | bool          | true              |
| manage_cloudflare| Enable Cloudflare DNS management         | bool          | true              |

## Outputs
| Name           | Description                              |
|----------------|------------------------------------------|
| ipv4_address   | The VM's IPv4 address                    |
| allowed_ips    | List of allowed IPs (Cloudflare)         |

## Requirements
- Proxmox VE 7+
- Terraform 1.3+
- Providers:
  - bpg/proxmox >= 0.50.0
  - cloudflare (for firewall integration)

## Cloud-init Template
The module uses a cloud-init template to:
- Set up the hostname
- Add your SSH key
- Install Docker & Dokku
- Run initial setup scripts

## Security
- By default, all IPs are allowed. Restrict with `allowed_ips` for production.
- Cloudflare integration requires your DNS zone to be managed by Cloudflare.

## License
MIT

---
PRs and issues welcome!