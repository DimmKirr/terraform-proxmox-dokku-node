terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.50.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }


}
