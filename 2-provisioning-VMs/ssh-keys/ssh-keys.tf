resource "tls_private_key" "ssh_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "local_file" "private_key" {
    filename        = "${path.module}/id_rsa"
    content         = tls_private_key.ssh_key.private_key_pem
    file_permission = "0600"
}

resource "local_file" "public_key" {
    filename        = "${path.module}/id_rsa.pub"
    content         = tls_private_key.ssh_key.public_key_openssh
    file_permission = "0644"
}
