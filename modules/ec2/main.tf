data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["137112412989"] # Amazon's official account ID
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids 
  key_name               = aws_key_pair.terraform_key.key_name

  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_instance" "private_servers" {
  count                  = 3
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids  # This should include the private_sg_id
  key_name               = aws_key_pair.terraform_key.key_name

 # Attach IAM Instance Profile for CloudWatch Logs
  iam_instance_profile = var.iam_instance_profile

  tags = {
    Name = "Private-Server-${count.index + 1}"
  }
}

