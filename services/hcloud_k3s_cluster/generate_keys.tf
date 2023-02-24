locals {
  certificates_names = ["client-ca", "server-ca", "request-header-key-ca"]
  certificates_types = { for s in local.certificates_names : index(local.certificates_names, s) => s }
  certificates_by_type = { for s in local.certificates_names : s =>
    tls_self_signed_cert.kubernetes_ca_certs[index(local.certificates_names, s)].cert_pem
  }
  certificates_files = flatten(
    [
      [for s in local.certificates_names :
        flatten([
          {
            "file_name"    = "${s}.key"
            "file_content" = tls_private_key.kubernetes_ca[index(local.certificates_names, s)].private_key_pem
          },
          {
            "file_name"    = "${s}.crt"
            "file_content" = tls_self_signed_cert.kubernetes_ca_certs[index(local.certificates_names, s)].cert_pem
          }
        ])
      ]
    ]
  )
  cluster_ca_certificate = local.certificates_by_type["server-ca"]
  client_certificate     = tls_locally_signed_cert.master_user[0].cert_pem
  client_key             = tls_private_key.master_user[0].private_key_pem
}

output "certificate_files" {
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
}

# Keys
resource "tls_private_key" "kubernetes_ca" {
  count = 3

  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

# certs
resource "tls_self_signed_cert" "kubernetes_ca_certs" {
  for_each = local.certificates_types

  validity_period_hours = 876600 # 100 years
  allowed_uses          = ["digital_signature", "key_encipherment", "cert_signing"]
  private_key_pem       = tls_private_key.kubernetes_ca[each.key].private_key_pem
  is_ca_certificate     = true

  subject {
    common_name = "kubernetes-${each.value}"
  }
}

# master-login cert
resource "tls_private_key" "master_user" {
  count = 1

  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_cert_request" "master_user" {
  count = 1

  private_key_pem = tls_private_key.master_user[0].private_key_pem

  subject {
    common_name  = "master-user"
    organization = "system:masters"
  }
}

resource "tls_locally_signed_cert" "master_user" {
  count = 1

  cert_request_pem   = tls_cert_request.master_user[0].cert_request_pem
  ca_private_key_pem = tls_private_key.kubernetes_ca[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.kubernetes_ca_certs[0].cert_pem

  validity_period_hours = 876600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth"
  ]
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "tls_public_key" "rsa" {
  private_key_pem = tls_private_key.rsa.private_key_pem
}

resource "hcloud_ssh_key" "default" {
  name       = var.cluster
  public_key = data.tls_public_key.rsa.public_key_openssh
}

resource "random_string" "k3s_token" {
  length  = 64
  special = false
}
