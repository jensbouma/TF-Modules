resource "hcloud_network" "network" {
  name     = "${var.cluster} network"
  ip_range = var.network.ip_range
}

resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = var.network.network_zone
  ip_range     = var.network.subnet_ip_range
}
