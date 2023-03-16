terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.36.2"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}
