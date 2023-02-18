resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "tls_public_key" "rsa" {
  private_key_pem = tls_private_key.rsa.private_key_pem
}

resource "hcloud_ssh_key" "default" {
  name       = var.cluster
  public_key = data.tls_public_key.rsa.public_key_openssh
}

resource "random_string" "k3s_token" {
  length  = 64
  special = false
}

resource "time_sleep" "k3s_installed" {
  depends_on      = [hcloud_server.node]
  for_each        = hcloud_server.node
  create_duration = "120s"
}

data "remote_file" "kubeconfig" {
  depends_on = [time_sleep.k3s_installed]
  conn {
    host = values({
      for node, val in var.nodes : node => {
    ipv4_address = zipmap(values(hcloud_server.node)[*].name, values(hcloud_server.node)[*])["${node}.${var.cluster}"].ipv4_address } if val.k3s_type == "master" })[0].ipv4_address
    user        = "root"
    private_key = data.tls_public_key.rsa.private_key_pem
    sudo        = true
  }
  path = "/etc/rancher/k3s/k3s.yaml"
}