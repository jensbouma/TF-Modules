variable "nodes" {
  default = {
    "node-01" = {
      k3s_type     = "master"
      provider     = "hcloud"
      zone         = "fsn1"
      machine_type = "cx11"
      keep_disk    = true
      ipv4_enabled = true
      ipv6_enabled = true
      private_ip   = "10.100.1.1"
    }
    "node-02" = {
      k3s_type     = "server"
      provider     = "hcloud"
      zone         = "nbg1"
      machine_type = "cx11"
      keep_disk    = true
      ipv4_enabled = true
      ipv6_enabled = true
      private_ip   = "10.100.2.1"
    }
    "node-03" = {
      k3s_type     = "server"
      provider     = "hcloud"
      zone         = "hel1"
      machine_type = "cx11"
      keep_disk    = false
      ipv4_enabled = true
      ipv6_enabled = true
      private_ip   = "10.100.3.1"
    }
  }
}

variable "network" {
  default = {
    ip_range        = "10.0.0.0/8"
    subnet_ip_range = "10.100.0.0/16"
    network_zone    = "eu-central"
  }
}

variable "cluster" {
}

variable "host_image" {
  default = "debian-11"
}

variable "firewall" {
  default = {
    /* "ping" = {
      port       = ""
      protocol   = "icmp"
      direction  = "in"
      source_ips = ["0.0.0.0/0", "::/0"]
    } */
    /* "ingress_https" = {
      port       = "443"
      protocol   = "tcp"
      direction  = "in"
      source_ips = ["0.0.0.0/0"]
    } */
    /* "ingress_http" = {
      port       = "80"
      protocol   = "tcp"
      direction  = "in"
      source_ips = ["0.0.0.0/0"]
    } */
  }
}

variable "s3_bucket" {
}

variable "cloudflare_tunnel" {
}
