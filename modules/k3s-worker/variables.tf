variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "server_type" {
  type = string
}

variable "location" {
  type = string
}

variable "network" {
  type = object({
    id = string
    ip = optional(string)
  })
}

variable "ssh_authorized_keys" {
  type      = list(string)
  sensitive = true
  default   = []
}

variable "worker_private_ssh_key" {
  type      = string
  sensitive = true
}
