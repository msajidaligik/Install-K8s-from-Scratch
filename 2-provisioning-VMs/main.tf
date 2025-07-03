resource "libvirt_volume" "k8s_nodes_volume" {
    for_each = var.vms_configurations

    name = "k8s-${each.key}-volume"
    pool = "default"
    source = var.base_os_image
    format = "raw"
}

resource "libvirt_network" "k8s_network" {
    name = "k8s_network"
    mode = "nat"
    addresses = var.addresses_for_network
    autostart = true
}

module "ssh_keys" {
  source = "./ssh_keys"
}

resource "libvirt_cloudinit_disk" "k8s_nodes_cloudinit" {
    for_each = var.vms_configurations

    name = "k8s-${each.key}-cloudinit.iso"
    pool = "default"
    user_data = templatefile("${path.module}/cloud-init.tpl", {
        hostname = each.key
        ip = each.value.ip
        ssh_key = module.ssh_keys.public_key
    })
}

resource "libvirt_domain" "k8s_nodes" {
    for_each = var.vms_configurations

    name = "k8s-${each.key}-node"
    memory = each.value.memory
    vcpu = each.value.cpus

    disk{
        volume_id = libvirt_volume.k8s_nodes_volume[each.key].id
    }

    network_interface{
        network_id = libvirt_network.k8s_network.id
        hostname = each.key
        wait_for_lease = true
    }

    cloudinit = libvirt_cloudinit_disk.k8s_nodes_cloudinit[each.key].id

    console {
        type = "pty"
        target_port = "0"
        target_type = "serial"
    }
}