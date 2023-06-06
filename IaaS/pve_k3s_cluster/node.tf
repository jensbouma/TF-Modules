locals {
  master_ip = try([for node in var.nodes : node.private_ip if node.k3s_type == "master"][0], "")
}

data "template_file" "cloud-init" {
  for_each = var.nodes
  template = templatefile("${path.module}/cloud_init.tftpl",
    {
      name               = each.key
      node               = each.value
      master_ip          = local.master_ip
      subnet_ip_range    = var.network.subnet_ip_range
      k3s_token          = random_string.k3s_token.result
      s3_bucket          = var.s3_bucket
      /* s3_bucket_name     = "${var.cluster}-etcd-backup" */
      certificates_files = local.certificates_files
    }
  )
}

# resource "hcloud_placement_group" "group" {
#   name = var.cluster
#   type = "spread"
# }

# resource "hcloud_server" "node" {
#   depends_on = [hcloud_network_subnet.subnet]
#   for_each   = var.nodes

#   name               = "${each.key}.${var.cluster}"
#   placement_group_id = hcloud_placement_group.group.id

#   location    = each.value.zone
#   server_type = each.value.machine_type

#   image     = var.host_image
#   keep_disk = each.value.keep_disk

#   ssh_keys = [hcloud_ssh_key.default.id]

#   user_data = data.template_file.cloud-init[each.key].rendered

#   firewall_ids = each.value.k3s_type == "master" ? concat([hcloud_firewall.master_node.id], values(hcloud_firewall.firewall)[*].id) : values(hcloud_firewall.firewall)[*].id

#   public_net {
#     ipv4_enabled = each.value.ipv4_enabled
#     ipv6_enabled = each.value.ipv6_enabled
#   }
#   network {
#     network_id = hcloud_network.network.id
#     ip         = each.value.private_ip
#   }
# }


resource "proxmox_vm_qemu" "cloudinit-test" {
    for_each    = var.nodes
    name        = each.key

    target_node = "pve"
    pool = "Pool-01"

    # The template name to clone this vm from
    clone = "ci-ubuntu-template"

    agent = 1
    cores   = 2
    sockets = 1
    memory  = 4048
    
    ssh_user        = "root"
    ssh_private_key = data.tls_public_key.rsa.public_key_openssh
    os_type = "cloud-init"
  
    # # Setup the disk
    disk {
        size = "30G"
        type = "scsi"
        storage = "local-lvm"
        iothread = 1
        ssd = 1
    }

    # Setup the network interface and assign a vlan tag: 0
    network {
        model = "virtio"
        bridge = "vmbr0"
        tag = 0
    }

    # Setup the ip address using cloud-init.
    # Keep in mind to use the CIDR notation for the ip.
    ipconfig0 = "ip=${each.value.private_ip}/24,gw=192.168.10.253"
    cicustom = data.template_file.cloud-init[each.key].rendered

    # provisioner "remote-exec" {
    #     inline = [
    #         "ip a"
    #     ]
    # }
}