
output "kubeconfig" {
  value     = module.hcloud_k3s_cluster.kubeconfig
  sensitive = true
}

output "cluster_hostname" {
  value = module.hcloud_k3s_cluster.cluster_hostname
}

output "longhorn_password" {
  value     = module.hcloud_k3s_cluster.longhorn_password
  sensitive = true
}

output "private_key" {
  value = module.hcloud_k3s_cluster.private_key
  sensitive = true
}
