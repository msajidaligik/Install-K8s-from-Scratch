#cloud-config
hostname: ${hostname}
manage_etc_hosts: true
users:
  - default
  - name: ubuntu
    ssh-authorized-keys:
      - ${ssh_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash

package_update: true
package_upgrade: true
packages:
  - openssh-server

write_files:
  - path: /etc/netplan/01-netcfg.yaml
    content: |
      network:
        version: 2
        renderer: networkd
        ethernets:
          ens3:
            dhcp4: no
            addresses: [${ip}/24]
            gateway4: 192.168.122.1
            nameservers:
              addresses: [8.8.8.8,8.8.4.4]

runcmd:
  - netplan apply