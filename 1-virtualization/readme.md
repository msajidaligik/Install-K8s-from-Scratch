# QEMU/KVM + Libvirt Installation Guide 

 This guide helps you install **KVM**, **Libvirt**, and essential virtualization tools on a Debian-based Linux system. 
 

## Prerequisites 

- A Linux system with virtualization support (check with `egrep -c '(vmx|svm)' /proc/cpuinfo`) 

- A user account with `sudo` privileges 

--- 

## 1. Install QEMU/KVM, Libvirt 

Run the following commands to install the necessary packages: 


```bash 

sudo apt update 

sudo apt-get install qemu-system  

sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager 

``` 

## 2. Add your user to the libvirt group 

```bash 

sudo usermod -aG libvirt $USER 

newgrp libvirt 

 
# Optional: Reboot your system to fully apply group membership changes. 

``` 

## 3. Verify the Installation 

```bash 

virsh list -all 

``` 

## 4. Troubleshooting 

- If virsh commands fail, try restarting the libvirt service: 

```bash 

sudo systemctl restart libvirtd 

``` 

- Check group membership with: 

```bash 

groups $USER 


#If libvirt is not listed, reboot or run newgrp libvirt. 

``` 