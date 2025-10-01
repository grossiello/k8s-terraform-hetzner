locals {
  _master_nodes = var.nodes.master
  _worker_nodes = var.nodes.worker

  master_nodes = [
    for master in local._master_nodes : {
      name        = master.name
      image       = master.image
      server_type = master.server_type
      location    = master.location
      ip          = master.ip

      ssh_authorized_keys = concat([var.public_ssh_key], [for worker in local._worker_nodes : var.ssh_keys[worker.name].public_ssh_key], var.ssh_keys[master.name].ssh_authorized_keys)
    }
  ]

  worker_nodes = [
    for worker in local._worker_nodes : {
      name        = worker.name
      image       = worker.image
      server_type = worker.server_type
      location    = worker.location

      ssh_authorized_keys = concat([var.public_ssh_key], var.ssh_keys[worker.name].ssh_authorized_keys)

      worker_private_ssh_key = var.ssh_keys[worker.name].private_ssh_key
    }
  ]
}
