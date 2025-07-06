
# VM Provisioning with Terraform & Libvirt

This Terraform script provisions virtual machines (VMs) using the [Libvirt provider](https://github.com/dmacvicar/terraform-provider-libvirt). It is intended to be run **after completing the "1-virtualization" setup** and assumes you have the necessary virtualization tools installed on your system.

---

## 📋 Prerequisites

1. **Virtualization Support**  
   Make sure you have completed the steps in the `1-virtualization` setup guide and installed required packages mentioned.

2. **Cloud Image**  
   This script requires a **pre-built cloud image** (such as Ubuntu). You can download one from the official source:  
   👉 [https://cloud-images.ubuntu.com](https://cloud-images.ubuntu.com)

   Example: Ubuntu 22.04 cloud image (`.img` or `.qcow2`)

3. **Configuration**  
   Edit the `variables.tf` file to configure:
   - VM names, CPU, memory, and storage
   - Static IP addresses
   - Path to the base cloud image
   - Number of nodes

---

## 🚀 How to Use

Once you’ve installed Terraform and completed the above prerequisites:

#### 1. Initialize Terraform
```bash
terraform init
```
#### 2. (Optional) Preview the Plan
```bash
terraform Plan
```
#### 3. Apply the Terraform Script
```bash
terraform apply
```

## ✅ Outputs
After a successful run, Terraform will output:

#### SSH Key Paths

 - Public and private key files for accessing your VMs.

#### SSH Connection Info

 - Username and IP addresses (both static and dynamic).

 - 🔐 You can SSH into the VMs using the generated private key, the provided username, and either the static or dynamic IP.
