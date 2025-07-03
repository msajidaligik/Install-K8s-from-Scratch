terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.1.0"
    }

    local = {
      source = "hashicorp/local"
      version = "2.5.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}