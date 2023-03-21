output "longhorn" {
  value = helm_release.longhorn
  sensitive = true
}