output "private_key_file"{
   value = module.ssh_keys.private_key_file
}

output "public_key_file"{
   value = module.ssh_keys.public_key_file
}

output "vm_ssh_info_set_by_clouinit_tpl" {
  value = {
    for name, config in var.vms_configurations :
    name => {
      hostname = name
      ip       = config.ip
      username = "ubuntu"
    }
  }
}

output "vm_ssh_info_set_by_dhcp" {
  value = {
    for name, vm in libvirt_domain.k8s_nodes :
    name => {
      vmname = vm.name
      ip       = vm.network_interface[0].addresses[0]
      username = "ubuntu" # Set based on your image
    }
  }
}
