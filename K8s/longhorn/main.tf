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
