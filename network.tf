resource "hcloud_network" "private_network" {
  name     = var.network.name
  ip_range = var.network.ip_range
}

resource "hcloud_network_subnet" "private_network_subnet" {
  count        = length(var.subnets)
  type         = var.subnets[count.index].type
  network_id   = hcloud_network.private_network.id
  network_zone = var.subnets[count.index].network_zone
  ip_range     = var.subnets[count.index].ip_range
}
