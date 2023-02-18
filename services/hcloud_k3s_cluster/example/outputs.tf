
output "kubeconfig" {
  value = module.hcloud_k3s_cluster.kubeconfig
  sensitive = true
}

/* output "private_key" {
  value = module.hcloud_k3s_cluster.private_key
  sensitive = true
} */

/* output "ipv4_address" {
  value = values({
      for node, val in local.nodes : node => {
        ipv4_address = module.hcloud_k3s_cluster.node_map["${node}.${local.cluster}"].ipv4_address
      } if val.k3s_type == "master"
    })[0].ipv4_address
} */

/* output "cloud-init" {
  value = module.hcloud_k3s_cluster.cloud-init
  sensitive = true
} */

output "hostname" {
  value = module.hcloud_k3s_cluster.hostname
}