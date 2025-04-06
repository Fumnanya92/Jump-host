resource "tls_private_key" "terraform" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "terraform_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.terraform.public_key_openssh
}

resource "local_file" "tfkey" {
  content  = tls_private_key.terraform.private_key_pem
  filename = var.private_key_path
  #sensitive = true  # Mark the file as sensitive
}
