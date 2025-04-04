output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_1_id" {
  description = "The ID of the first public subnet"
  value       = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id" {
  description = "The ID of the second public subnet"
  value       = module.vpc.public_subnet_2_id
}

output "private_subnet_1_id" {
  description = "The ID of the first private subnet"
  value       = module.vpc.private_subnet_1_id
}

output "private_subnet_2_id" {
  description = "The ID of the second private subnet"
  value       = module.vpc.private_subnet_2_id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "bastion_ip" {
  description = "The public IP of the Bastion Host instance"
  value       = module.ec2.bastion_instance_public_ip
}

output "nginx_servers" {
  description = "The IDs of the Private Server instances"
  value       = module.ec2.private_server_instance_ip
}



