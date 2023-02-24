terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "kubernetes" {
    host = local.kubeconfig.host
    cluster_ca_certificate = local.kubeconfig.cluster_ca_certificate
    client_certificate = local.kubeconfig.client_certificate
    client_key = local.kubeconfig.client_key
}

provider "helm" {
    kubernetes {
      host = local.kubeconfig.host
      cluster_ca_certificate = local.kubeconfig.cluster_ca_certificate
      client_certificate = local.kubeconfig.client_certificate
      client_key = local.kubeconfig.client_key
    }
}