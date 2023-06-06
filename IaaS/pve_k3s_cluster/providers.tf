terraform {
  cloud {
    organization = "jensbouma"
    workspaces {
      name = "onprem_staging_cluster"
    }
    required_providers {
     proxmox = {
      source  = "telmate/proxmox"
       version = ">=1.0.0"
     }
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = var.PM_API_URL
    pm_api_token_id = var.PM_API_TOKEN_ID
    pm_api_token_secret = var.PM_API_TOKEN_SECRET
}