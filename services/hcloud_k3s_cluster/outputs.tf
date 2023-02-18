output "private_key" {
  value     = data.tls_public_key.rsa.private_key_pem
  sensitive = true
}

output "kubeconfig" {
  depends_on = [
    data.remote_file.kubeconfig
  ]
  value = {
    host                   = yamldecode(data.remote_file.kubeconfig.content).clusters[0].cluster.server
    cluster_ca_certificate = base64decode(yamldecode(data.remote_file.kubeconfig.content).clusters[0].cluster.certificate-authority-data)
    client_certificate     = base64decode(yamldecode(data.remote_file.kubeconfig.content).users[0].user.client-certificate-data)
    client_key             = base64decode(yamldecode(data.remote_file.kubeconfig.content).users[0].user.client-key-data)
  }
  sensitive = true
}

output "cloud-init" {
  value     = values(data.template_file.cloud-init)[*].rendered
  sensitive = true
}

output "cluster_hostname" {
  value = cloudflare_record.tunnel.hostname
}