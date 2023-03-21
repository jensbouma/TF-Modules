locals {
  /* kubeconfig = data.terraform_remote_state.prod_cluster.outputs.kubeconfig */
  cluster = var.cluster
  zones = var.zones
}