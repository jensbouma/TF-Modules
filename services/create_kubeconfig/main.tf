terraform {
}

data "terraform_remote_state" "prod_services_cluster" {
  backend = "remote"

  config = {
    organization = var.organization
    workspaces = {
      name = var.workspace
    }
  }
}

module "kubeconfig" {
  source  = "./terraform-kubernetes-kubeconfig"

  current_context = var.cluster_hostname
  clusters = [{
    "name" : var.cluster_hostname
    "server" : var.kubeconfig.host,
    certificate_authority_data = base64encode(var.kubeconfig.cluster_ca_certificate)
  }]
  contexts = [{
    "name" : var.cluster_hostname
    "cluster_name" : var.cluster_hostname
    "user" : "default"
  }]
  users = [{
    "name" : "default",
    "client_certificate_data" : base64encode(var.kubeconfig.client_certificate)
    "client_key_data" : base64encode(var.kubeconfig.client_key)
    }]
}
