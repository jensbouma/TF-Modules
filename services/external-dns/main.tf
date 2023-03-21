data "cloudflare_api_token_permission_groups" "all" {}

resource "cloudflare_api_token" "zone_dns_edit" {
  name = "${var.cluster}-dns"

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.zone["DNS Write"],
    ]
    resources = {
      "com.cloudflare.api.account.zone.${var.zones.clusterfuck_cloud.id}" = "*"
      "com.cloudflare.api.account.zone.${var.zones.groundschool_nl.id}" = "*"
    }
  }
}

resource "kubernetes_namespace" "external_dns" {
  metadata {
    name        = "external-dns"
    annotations = {}
    labels      = {}
  }
}

resource "kubernetes_secret" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = kubernetes_namespace.external_dns.metadata[0].name
  }

  data = {
    "cloudflare_api_token" = cloudflare_api_token.zone_dns_edit.value
  }

  type = "kubernetes.io/secret"
}

resource "helm_release" "external_dns" {
  name = "external-dns"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  namespace = kubernetes_namespace.external_dns.metadata[0].name

  set {
    name  = "provider"
    value = "cloudflare"
  }

  set {
    name  = "cloudflare.secretName"
    value = kubernetes_secret.external_dns.metadata[0].name
  }

  set {
    name  = "txtOwnerId"
    value = var.tunnel.name
  }

  set {
    name  = "registry"
    value = "txt"
  }

  set {
    name  = "policy"
    value = "sync"
  }
}
