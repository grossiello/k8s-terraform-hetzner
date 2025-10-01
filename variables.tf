variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "public_ssh_key" {
  type      = string
  sensitive = true
}

variable "network" {
  type = object({
    name     = string
    ip_range = string
  })
  default = {
    name     = "k8s"
    ip_range = "10.0.0.0/16"
  }
}

variable "subnets" {
  type = list(object({
    type         = string
    network_zone = string
    ip_range     = string
  }))
  default = [{
    type         = "cloud"
    network_zone = "eu-central"
    ip_range     = "10.0.1.0/24"
  }]
}

variable "nodes" {
  type = object({
    master = optional(list(object({
      name        = string
      image       = string
      server_type = string
      location    = string
      ip          = string
    })))
    worker = optional(list(object({
      name        = string
      image       = string
      server_type = string
      location    = string
    })))
  })
  default = {
    master = [{
      name        = "master"
      image       = "ubuntu-24.04"
      server_type = "cax11"
      location    = "fsn1"
      ip          = "10.0.1.1"
    }]
    worker = [{
      name        = "worker-0"
      image       = "ubuntu-24.04"
      server_type = "cax11"
      location    = "fsn1"
      }, {
      name        = "worker-1"
      image       = "ubuntu-24.04"
      server_type = "cax11"
      location    = "fsn1"
      }, {
      name        = "worker-2"
      image       = "ubuntu-24.04"
      server_type = "cax11"
      location    = "fsn1"
    }]
  }
}

variable "ssh_keys" {
  type = map(object({
    public_ssh_key      = optional(string)
    private_ssh_key     = optional(string)
    ssh_authorized_keys = optional(list(string), [])
  }))
  sensitive = true
  validation {
    condition = length(setintersection([keys(var.ssh_keys)], concat([var.nodes.master[*].name], [var.nodes.worker[*].name]))) == length(keys(var.ssh_keys))

    error_message = <<-EOT
      Validation failed: The keys provided in the 'ssh_keys' variable do not all match the 'name' attributes of the master and worker nodes.
      Provided keys: ${keys(var.ssh_keys)}
      Expected master names: ${var.nodes.master[*].name}
      Expected worker names: ${var.nodes.worker[*].name}
      EOT
  }
}
