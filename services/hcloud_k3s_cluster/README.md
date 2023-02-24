# Hetzner Cloud Kubernettes Cluster

Terraform module for creating a kubernettes cluster on the Hetzner cloud with Longhorn, Nginx ingress, External-dns and Cloudflared installed.

The nodes are completely installed via dynamically generated cloud-init templates.

The cloud-init files contains the pre generated certificates and are copyed before installing k3s. The certificates are outputed to use upstream kubernetes providers.


|  Included in module |       |
|---                    |---    |
|  Hcloud network       |  ✅   |
|  Hcloud firewall      |  ✅   |
|  Generate secrets     |  ✅   |
|  Generate certificates|  ✅   |
|  Hcloud node setup    |  ✅   |
|  Cloud-init K3S setup |  ✅   |
|  S3 etcd backup       |  ✅   |
|  Ngnix Ingress        |  ✅   |
|  Longhorn storage     |  ✅   |
|  Longhorn password    |  ✅   |
|  Cloudflared tunnel   |  ✅   |
|  Cloudflare DNS record|  ✅   |
|  Cloudflare api key   |  ✅   |
|  External-dns         |  ✅   |
