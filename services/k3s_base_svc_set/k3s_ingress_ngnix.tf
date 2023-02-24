resource "kubernetes_namespace" "nginx_ingress" {
  depends_on = [time_sleep.k3s_installed]
  metadata {
    name        = "nginx-ingress"
    annotations = {}
    labels      = {}
  }
}

resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-controller"

  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"

  namespace = kubernetes_namespace.nginx_ingress.metadata[0].name

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "replicaCount"
    value = 1
  }
}
/* 

resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  namespace = kubernetes_namespace.nginx_ingress.metadata[0].name

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "replicaCount"
    value = 3
  }
} */