terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "kubernetes" {
  host                   = "https://${hcloud_server.node[values({ for key, val in var.nodes : key => key if val.k3s_type == "master" })[0]].ipv4_address}:6443"
  cluster_ca_certificate = local.certificates_by_type["server-ca"]
  client_certificate     = tls_locally_signed_cert.master_user[0].cert_pem
  client_key             = tls_private_key.master_user[0].private_key_pem
}

provider "helm" {
  kubernetes {
    host                   = "https://${hcloud_server.node[values({ for key, val in var.nodes : key => key if val.k3s_type == "master" })[0]].ipv4_address}:6443"
    cluster_ca_certificate = local.certificates_by_type["server-ca"]
    client_certificate     = tls_locally_signed_cert.master_user[0].cert_pem
    client_key             = tls_private_key.master_user[0].private_key_pem
  }
}