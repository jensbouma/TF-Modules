terraform {
  cloud {
    organization = "jensbouma"
    }
     required_providers {
     proxmox = {
      source  = "telmate/proxmox"
       version = ">=1.0.0"
     }
  }
}
