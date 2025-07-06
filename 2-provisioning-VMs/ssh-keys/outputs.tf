output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}

output "private_key_file" {
  value     = local_file.private_key.filename
}

output "public_key_file" {
  value = local_file.public_key.filename
}
