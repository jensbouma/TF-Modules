# terraform-kubernetes-kubeconfig
Generate kubeconfig files with Terraform

## Example

```hcl
module "kubeconfig" {
  source  = "redeux/kubeconfig/kubernetes"
  version = "0.0.2"

  current_context = "kind-kind"
  clusters = [{
    "name" : "kind-kind",
    "server" : "https://127.0.0.1:53851",
    certificate_authority_data = ""
  }]
  contexts = [{
    "name" : "kind-kind",
    "cluster_name" : "kind-kind"
    "user" : "kind-kind"
  }]
  users = [{
    "name" : "",
    "client_certificate_data" : ""
    "client_key_data" : ""
    }, {
    "name" : "kind-kind",
    "client_certificate_data" : ""
    "client_key_data" : ""
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.15.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >=2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | >=2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_clusters"></a> [clusters](#input\_clusters) | List of cluster configurations | <pre>set(object({<br>    name                       = optional(string)<br>    server                     = optional(string)<br>    certificate_authority      = optional(string)<br>    certificate_authority_data = optional(string)<br>    insecure_skip_tls_verify   = optional(bool)<br>  }))</pre> | n/a | yes |
| <a name="input_colors"></a> [colors](#input\_colors) | Colors | `bool` | `true` | no |
| <a name="input_contexts"></a> [contexts](#input\_contexts) | List of context configurations | <pre>set(object({<br>    name         = optional(string)<br>    cluster_name = optional(string)<br>    namespace    = optional(string)<br>    user         = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_current_context"></a> [current\_context](#input\_current\_context) | Context name | `string` | `""` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Filename | `string` | `"kubeconfig"` | no |
| <a name="input_users"></a> [users](#input\_users) | List of user configurations | <pre>set(object({<br>    name                    = optional(string)<br>    username                = optional(string)<br>    password                = optional(string)<br>    token                   = optional(string)<br>    client_certificate      = optional(string)<br>    client_key              = optional(string)<br>    client_certificate_data = optional(string)<br>    client_key_data         = optional(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig_content"></a> [kubeconfig\_content](#output\_kubeconfig\_content) | HCL representation of kubeconfig file contents |
| <a name="output_kubeconfig_path"></a> [kubeconfig\_path](#output\_kubeconfig\_path) | Path to the kubeconfig file |