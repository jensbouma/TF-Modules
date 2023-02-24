## Before run

 Create a varibale set on Terraform cloud or create a variables.tfvars file with the following variables.

```
hcloud_token                    = ""
cloudflare_account_email        = ""
cloudflare_account_id           = ""
cloudflare_token                = ""
cloudflare_r2_access_key_id     = ""
cloudflare_r2_secret_access_key = ""

```

## Terraform commands
**Install terraform on macOS**
```
brew terraform
```
**Plan terraform run**
```
terraform plan
```
**Apply terraform run**
```
terraform apply
```
**Get list of outputs**
```
terraform output list
```
**Get outputs kubeconfig**
```
terraform output kubeconfig
```

