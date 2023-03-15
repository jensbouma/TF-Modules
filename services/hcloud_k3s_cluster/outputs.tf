output "private_key" {
  value     = data.tls_public_key.rsa.private_key_pem
  sensitive = true
}

output "kubeconfig" {
  value = {
    host                   = "https://${hcloud_server.node[values({ for key, val in var.nodes : key => key if val.k3s_type == "master" })[0]].ipv4_address}:6443"
    /* host                   = "https://${local.master_ip}:6443"    */
    cluster_ca_certificate = local.certificates_by_type["server-ca"]
    client_certificate     = tls_locally_signed_cert.master_user[0].cert_pem
    client_key             = tls_private_key.master_user[0].private_key_pem
  }
  sensitive = true
}

/* output "cluster_hostname" {
  value = cloudflare_record.tunnel.hostname
}

output "longhorn_password" {
  value     = random_password.longhorn.result
  sensitive = true
} */


/* output "certificate_files" {
  value     = local.certificates_files
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = local.cluster_ca_certificate
  sensitive = true
}

output "client_certificate" {
  value     = local.client_certificate
  sensitive = true
}

output "client_key" {
  value     = local.client_key
  sensitive = true
} */