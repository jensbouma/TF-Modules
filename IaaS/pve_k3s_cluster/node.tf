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


# resource "proxmox_vm_qemu" "cloudinit-test" {
    
#     name        = "ubuntu-01"
#     desc        = "First Ubuntu Server from Terraform"

#     # Node name has to be the same name as within the cluster
#     # this might not include the FQDN
#     target_node = "pve"

#     # The destination resource pool for the new VM
#     pool = "Pool-01"

#     # The template name to clone this vm from
#     clone = "ci-ubuntu-template"

#     #  # Activate QEMU agent for this VM
#     # agent = 1
#     cores   = 2
#     sockets = 1
#     memory  = 2048
    
# #     ssh_user        = "root"
# #     ssh_private_key = <<EOF
# # -----BEGIN RSA PRIVATE KEY-----
# # private ssh key root
# # -----END RSA PRIVATE KEY-----
# # EOF

#     os_type = "cloud-init"
  
#     # # Setup the disk
#     disk {
#         size = "10G"
#         type = "scsi"
#         storage = "local-lvm"
#         iothread = 1
#         ssd = 1
#     #     # discard = "on"
#     }

#     # Setup the network interface and assign a vlan tag: 0
#     network {
#         model = "virtio"
#         bridge = "vmbr0"
#         tag = 0
#     }

#     # Setup the ip address using cloud-init.
#     # Keep in mind to use the CIDR notation for the ip.
#     ipconfig0 = "ip=192.168.10.21/24,gw=192.168.10.253"

#     sshkeys = <<EOF
#     ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1fCKcLNiH1C5HKa0uPbYRTI+0jvZBdVtbka3DTrjxZRErdiug1/up77/ozZt7XXjWSO2bBouTJPkVhxAcwp78s1U+8cHaiZz4YN68hVBhRoJnGR7yFuWLVwGarrRVnfQeWctXODRfruUaEKNmWY4yrajUaitDbsKPnnCxLH3ZzkEKxOR2GjP7/o/qB935ph1SROiNXkUDUI/81tn4gq569rgp7N1NnzNROnmQY30oWdgi/idKVAIqYWqcFVYRmWxjp3xXdGGxjgTSU3It3kAf4xLNgV9vecV+GX6VDzgSBAvcuer/LX8ZSoZ4wQaiE4lWPh48cR2Xu8a9R6pwT7dKIHqCjkjQOhaGxgaqaSzMyv2HwSbqCzxkNt+GwQ6IaQ1gsND9Jc5voBWkLBp30D09Ya2dytILsN9iG2THdyRMLcGmu6WT179D7oaUqhK+svx6FkgK3gszLnjKUYQe3lalSZpqyVw7lx7NgCehoqxyF8wZvD0dI3pS3cTLbFGfcmE= jensbouma@MacBook-Pro.local
#     EOF
 
#     # provisioner "remote-exec" {
#     #     inline = [
#     #         "ip a"
#     #     ]
#     # }
# }