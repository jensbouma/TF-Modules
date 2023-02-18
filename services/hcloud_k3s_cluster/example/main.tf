locals {
  cluster = "cluster"
  nodes = {
    "node01" = {
      k3s_type     = "master"
      provider     = "hcloud"
      zone         = "fsn1"
      machine_type = "cx11"
      keep_disk    = false
      ipv4_enabled = true
      ipv6_enabled = true
      private_ip   = "10.100.1.1"
    }
    "node02" = {
      k3s_type     = "server"
      provider     = "hcloud"
      zone         = "nbg1"
      machine_type = "cx11"
      keep_disk    = false
      ipv4_enabled = true
      ipv6_enabled = true
      private_ip   = "10.100.2.1"
    }
    "node03" = {
      k3s_type     = "server"
      provider     = "hcloud"
      zone         = "hel1"
      machine_type = "cx11"
      keep_disk    = false
      ipv4_enabled = true
      ipv6_enabled = true
      private_ip   = "10.100.3.1"
    }
    /* "node04" = {
      k3s_type     = "master"
      provider     = "hcloud"
      zone         = "fsn1"
      machine_type = "cx11"
      keep_disk    = false
      ipv4_enabled = true
      ipv6_enabled = true
      private_ip   = "10.100.4.1"
    } */
  }
  network = {
    ip_range        = "10.0.0.0/8"
    subnet_ip_range = "10.100.0.0/16"
    network_zone    = "eu-central"
  }
  cloudflare_zone = YOUR_CLOUDFLARE_ZONE_HERE
}

module "hcloud_k3s_cluster" {
  source      = "github.com/jensbouma/tf-modules//services/hcloud_k3s_cluster?ref=master"
  cluster     = local.cluster
  nodes       = local.nodes
  network     = local.network
  host_image  = "debian-11"
  reverse_dns = "jensbouma.com"
  s3_bucket = {
    region     = YOUR_REGIONS
    endpoint   = YOUR_ENDPOINT_WITHOUT_HTTPS//
    access_key = var.cloudflare_r2_access_key_id
    secret_key = var.cloudflare_r2_secret_access_key
  }
  cloudflare_zone = local.cloudflare_zone
  cloudflare_account_id = var.cloudflare_account_id
  providers = {
    hcloud     = hcloud
    cloudflare = cloudflare
  }
}