variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.161.0.0/24"
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
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
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
    Project = "Terraform-Ansible-Docker"
    Environment = "Dev"
  }
}
