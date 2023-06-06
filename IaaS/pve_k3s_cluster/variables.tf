variable "nodes" {}

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
  default = {}
}

variable "s3_bucket" {
}
