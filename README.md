# Hetzner Cloud Kubernettes Cluster

Terraform module for creating a kubernettes cluster on the Hetzner cloud.

After provisioning the cluster the kubeconfig file from the master-node gets downloaded to a output variable. In the kubernettes environment, Nginx ingress, external-dns and cloudflared are gonna be installed.

|  Included in module |       |
|---                    |---    |
|  Hcloud network       |  ✅   |
|  Hcloud firewall      |  ✅   |
|  Generate secrets     |  ✅   |
|  K3s cluster          |  ✅   |
|  S3 etcd backup       |  ✅   |
|  Hcloud node setup    |  ✅   |
|  Get kubeconfig       |  ✅   |
|  Ngnix Ingress        |  ✅   |
|  Cloudflared tunnel   |  ✅   |
|  Cloudflare api key   |  ✅   |
|  External-dns         |  ✅   |
|  Remote state outputs |  ✅   |


```
module "hcloud_k3s_cluster" {
  source      = "github.com/jensbouma/tf-modules//services/hcloud_k3s_cluster?ref=master"
  cluster     = local.cluster
  nodes       = local.nodes
  network     = local.network
  host_image  = "debian-11"
  s3_bucket = data.terraform_remote_state.global_storage.outputs.buckets
  cloudflare_zone = local.cloudflare_zone
  cloudflare_account_id = var.cloudflare_account_id
  providers = {
    hcloud     = hcloud
    cloudflare = cloudflare
  }
}
```