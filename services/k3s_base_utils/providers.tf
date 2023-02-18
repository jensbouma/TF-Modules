terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.36.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    remote = {
      source  = "tenstad/remote"
      version = "0.1.0"
    }
  }
}

provider "kubernetes" {
  host                   = yamldecode(data.remote_file.kubeconfig.content).clusters[0].cluster.server
  cluster_ca_certificate = base64decode(yamldecode(data.remote_file.kubeconfig.content).clusters[0].cluster.certificate-authority-data)
  client_certificate     = base64decode(yamldecode(data.remote_file.kubeconfig.content).users[0].user.client-certificate-data)
  client_key             = base64decode(yamldecode(data.remote_file.kubeconfig.content).users[0].user.client-key-data)
}

provider "helm" {
  kubernetes {
    host                   = yamldecode(data.remote_file.kubeconfig.content).clusters[0].cluster.server
    cluster_ca_certificate = base64decode(yamldecode(data.remote_file.kubeconfig.content).clusters[0].cluster.certificate-authority-data)
    client_certificate     = base64decode(yamldecode(data.remote_file.kubeconfig.content).users[0].user.client-certificate-data)
    client_key             = base64decode(yamldecode(data.remote_file.kubeconfig.content).users[0].user.client-key-data)
  }
}