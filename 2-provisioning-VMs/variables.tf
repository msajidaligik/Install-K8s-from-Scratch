variable "base_os_image" { 
    # pre-built cloud os image to use for VM
    # you may download of your choice from: https://cloud-images.ubuntu.com
    default = "./jammy-server-cloudimg-amd64.img"
}

variable "addresses_for_network" {
  default = ["192.168.100.0/24"]
}

variable "vms_configurations" {
    # storage will only if you want to resize the volume using the null_resource in the main.tf file
    # otherwise the default size of the source file will be used.
    # You may need to disable AppArmor if having permission issues
    default = {
        master = {ip = "192.168.100.101", memory = "1024", cpus = "1", storage = "22G", resize_storage = true}
        worker1 = {ip = "192.168.100.102", memory = "1024", cpus = "1", storage = "22G", resize_storage = true}
        worker2 = {ip = "192.168.100.103", memory = "1024", cpus = "1", storage = "22G", resize_storage = true}
    }
}
