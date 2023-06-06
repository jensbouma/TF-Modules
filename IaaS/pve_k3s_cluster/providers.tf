terraform {
  cloud {
    organization = "jensbouma"
    }
     required_providers {
     proxmox = {
      source  = "telmate/proxmox"
       version = ">=2.9.14"
     }
  }
}
