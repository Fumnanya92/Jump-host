data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (official Ubuntu owner ID)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = aws_key_pair.terraform_key.key_name

  # Pass base64-encoded private key to the instance for user data
  user_data = templatefile("${path.module}/userdata.sh", {
    private_key = base64encode(tls_private_key.terraform.private_key_pem)
  })

  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_instance" "private_servers" {
  count                  = 3
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids # This should include the private_sg_id
  key_name               = aws_key_pair.terraform_key.key_name

  # Attach IAM Instance Profile for CloudWatch Logs
  iam_instance_profile = var.iam_instance_profile

  tags = {
    Name = "Private-Server-${count.index + 1}"
  }
}
