variable "base_os_image" { 
    default = "path-to-os-iso-or-img-file"
}

variable "vms_to_create" {
    default = 3
}

variable "addresses_for_network" {
  default = "192.168.100.0/24"
}

variable "vms_configurations" {
    default = {
        master = {ip = "192.168.100.101", memory = "1024", cpus = "1" }
        worker1 = {ip = "192.168.100.102", memory = "1024", cpus = "1"}
        worker2 = {ip = "192.168.100.103", memory = "1024", cpus = "1"}
    }
}