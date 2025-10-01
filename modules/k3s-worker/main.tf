resource "hcloud_server" "worker" {
  name        = var.name
  image       = var.image
  server_type = var.server_type
  location    = var.location
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  network {
    network_id = hcloud_network.private_network.id
  }
  user_data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
    ssh_authorized_keys    = var.ssh_authorized_keys,
    worker_private_ssh_key = var.worker_private_ssh_key
  })
}
