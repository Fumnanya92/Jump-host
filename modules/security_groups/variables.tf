variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all security groups"
  type        = map(string)
}

variable "bastion_sg_id" {
  description = "The security group ID of the Bastion host"
  type        = string
}