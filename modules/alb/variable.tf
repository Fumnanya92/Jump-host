variable "vpc_id" {
  description = "VPC ID where ALB will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets where ALB should be deployed"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group for ALB"
  type        = string
}

variable "private_instance_ids" {
  description = "List of EC2 instance IDs in private subnets"
  type        = list(string)
}

variable "s3_bucket_id" {
  description = "S3 bucket for ALB logs"
  type        = string
}
