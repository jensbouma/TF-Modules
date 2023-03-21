resource "random_password" "longhorn" {
  length  = 16
  special = true
}

resource "kubernetes_namespace" "longhorn" {
  metadata {
    annotations = {
      name = "longhorn"
    }
    name = "longhorn"
  }
}

resource "kubernetes_secret" "aws_secret" {
  metadata {
    name      = "aws-secret"
    namespace = kubernetes_namespace.longhorn.id
  }

  data = {
    AWS_ACCESS_KEY_ID     = var.s3_bucket.access_key
    AWS_SECRET_ACCESS_KEY = var.s3_bucket.secret_key
    AWS_ENDPOINTS         = var.s3_bucket.https_endpoint
  }
}

resource "helm_release" "longhorn" {
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  namespace  = kubernetes_namespace.longhorn.id
  
  set {
    name  = "defaultSettings.backupTarget"
    value = var.longhorn_backup_target
  }
  set {
    name  = "defaultSettings.backupTargetCredentialSecret"
    value = "aws-secret"
  }

  set {
    name  = "storageclass.kubernetes\\.io/is-default-class"
    value = true
  }

  set {
    name  = "storageMinimalAvailablePercentage"
    value = 10
  }

  set {
    name = "defaultSettings.defaultReplicaCount"
    value = 2
  }

  set {
    name = "longhornUI.replicas"
    value = 1
  }
  
}

resource "kubernetes_secret" "longhorn" {
  metadata {
    name      = "longhorn-auth"
    namespace = kubernetes_namespace.longhorn.metadata[0].name
  }

  data = {
    "admin" = random_password.longhorn.bcrypt_hash
  }
}

/* resource "kubernetes_ingress_v1" "longhorn" {
  metadata {
    name      = "longhorn-dashboard"
    namespace = kubernetes_namespace.longhorn.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" : "nginx"
      "external-dns.alpha.kubernetes.io/target"      = cloudflare_record.tunnel.hostname
      "nginx.ingress.kubernetes.io/auth-type"        = "basic"
      "nginx.ingress.kubernetes.io/auth-secret-type" = "auth-map"
      "nginx.ingress.kubernetes.io/auth-secret"      = "${kubernetes_namespace.longhorn.metadata[0].name}/${kubernetes_secret.longhorn.metadata[0].name}"
      "nginx.ingress.kubernetes.io/auth-realm"       = "Authentication Required"

    }
  }
  spec {
    rule {
      host = "longhorn.${local.zones.clusterfuck_cloud.zone}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "longhorn-frontend"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
} */