module "k3s-master" {
  for_each    = local.master_nodes
  source      = "./modules/k3s-master"
  name        = each.value.name
  image       = each.value.image
  server_type = each.value.server_type
  location    = each.value.location

  network = {
    id = hcloud_network.private_network.id
    ip = each.value.ip
  }

  ssh_authorized_keys = each.value.ssh_authorized_keys

  providers = {
    hcloud = hcloud
  }
  depends_on = [hcloud_network_subnet.private_network_subnet]
}

module "k3s-worker" {
  for_each    = local.worker_nodes
  source      = "./modules/k3s-worker"
  name        = each.value.name
  image       = each.value.image
  server_type = each.value.server_type
  location    = each.value.location

  network = {
    id = hcloud_network.private_network.id
  }

  ssh_authorized_keys = each.value.ssh_authorized_keys

  worker_private_ssh_key = each.value.worker_private_ssh_key

  providers = {
    hcloud = hcloud
  }
  depends_on = [hcloud_network_subnet.private_network_subnet, module.k3s-master]
}
