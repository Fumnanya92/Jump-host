variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet ID for the bastion host"
  type        = string
}

variable "private_subnet_id" {
  description = "Subnet ID for private instances"
  type        = string
}

# variable "ami_id" {
#   description = "AMI ID for EC2 instances"
#   type        = string
#   default     = data.aws_ami.amazon_linux.id
# }

variable "key_pair_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "private_key_path" {
  description = "Path to store the private key"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instances"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile for EC2"
  type        = string
}

variable "instance_type"{
  description = "type of instance"
  type = string
}