resource "hcloud_firewall" "firewall" {
  for_each = var.firewall
  name     = "${var.cluster}-${each.key}"
  rule {
    port       = each.value.port
    direction  = each.value.direction
    protocol   = each.value.protocol
    source_ips = each.value.source_ips
  }
}

resource "hcloud_firewall" "master_node" {
  name = "${var.cluster}-terraform"
  /* rule {
    port       = "22"
    protocol   = "tcp"
    direction  = "in"
    source_ips = ["0.0.0.0/0"]
  } */
  rule {
    port       = "6443"
    protocol   = "tcp"
    direction  = "in"
    source_ips = ["0.0.0.0/0"]
  }
}