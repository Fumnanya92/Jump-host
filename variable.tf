variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.161.0.144/28"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.161.0.160/28"
}

variable "availability_zone_1" {
  description = "Availability Zone for subnet 1"
  type        = string
  default     = "us-west-2a"
}

variable "availability_zone_2" {
  description = "Availability Zone for subnet 2"
  type        = string
  default     = "us-west-2b"
}

variable "nat_gateway_ip" {
  description = "Elastic IP for the NAT Gateway"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "Terraform-Ansible-Docker"
    Environment = "Dev"
  }
}

variable "s3_bucket_name" {
  description = "S3 bucket name for ALB logs"
  type        = string
}


variable "key_pair_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "private_key_path" {
  description = "Path to store the private key"
  type        = string
  default     = "~/.ssh/my_terraform_key.pem" # Default path if not specified
}


