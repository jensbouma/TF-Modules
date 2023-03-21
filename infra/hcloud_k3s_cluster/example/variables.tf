variable "hcloud_token" {
  description = "Hetzner Cloud Token"
  sensitive   = true
  type        = string
}

variable "cloudflare_token" {
  sensitive   = true
  type        = string
  description = "Cloudflare Account Token"
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare Account ID"
}

variable "cloudflare_account_email" {
  type        = string
  description = "Cloudflare Account email"
}

variable "cloudflare_r2_access_key_id" {
  description = "R2 Key ID"
  sensitive   = true
  type        = string
}

variable "cloudflare_r2_secret_access_key" {
  description = "R2 Secret Key"
  sensitive   = true
  type        = string
}
