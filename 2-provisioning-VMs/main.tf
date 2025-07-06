resource "libvirt_volume" "k8s_nodes_volume" {
    for_each = var.vms_configurations

    name = "k8s-${each.key}-node-volume"
    pool = "default"
    source = var.base_os_image
    format = "qcow2"
}

# The default size will be the size of the source argument value so,
# this null_resource is being used for resizing the created volume
# please see documentation for libvirt_volume
# please make sure you have the sudo priviliges else you may comment out this resource block
# and the depends argument in the libvirt_domain resource block
locals {
  vm_nodes_to_resize = {
    for name, config in var.vms_configurations :
    name => config
    if config.resize_storage == true
  }
}
resource "null_resource" "resize_k8s_nodes_volume" {
  for_each = local.vm_nodes_to_resize
#  for_each = var.vms_configurations

  depends_on = [libvirt_volume.k8s_nodes_volume]

  provisioner "local-exec" {
    command = <<EOT
      VOLUME_PATH=$(virsh vol-path k8s-${each.key}-node-volume --pool default)
      sudo qemu-img resize -f qcow2 "$${VOLUME_PATH}" ${each.value.storage}
      sudo chown libvirt-qemu:kvm "$${VOLUME_PATH}"
      sudo chmod 0644 "$${VOLUME_PATH}"
    EOT
  }
}

resource "libvirt_network" "k8s_network" {
    name = "k8s_network"
    mode = "nat"
    addresses = var.addresses_for_network
    autostart = true
}

module "ssh_keys" {
  source = "./ssh-keys"
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
    
    depends_on = [libvirt_volume.k8s_nodes_volume, null_resource.resize_k8s_nodes_volume]
    
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
