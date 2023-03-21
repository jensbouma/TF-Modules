locals {
  /* kubeconfig = data.terraform_remote_state.prod_cluster.outputs.kubeconfig */
  cluster = var.cluster
  zones = var.zones
}

variable "cluster" {}

variable "zones" {}

variable "cloudflare_account_id" {}