resource "hcloud_network" "private_network" {
  name     = var.network.name
  ip_range = var.network.ip_range
}

resource "hcloud_network_subnet" "private_network_subnet" {
  for_each     = var.subnets[*]
  type         = each.value.type
  network_id   = hcloud_network.private_network.id
  network_zone = each.value.network_zone
  ip_range     = each.value.ip_range
}
