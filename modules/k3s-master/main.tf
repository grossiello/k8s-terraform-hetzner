resource "hcloud_server" "master" {
  name        = var.name
  image       = var.image
  server_type = var.server_type
  location    = var.location
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  network {
    network_id = var.network.id
    ip         = var.network.ip
  }
  user_data = templatefile("${path.module}/data/vm/cloud-init.yaml.tftpl", {
    ssh_authorized_keys = var.ssh_authorized_keys
  })
}
