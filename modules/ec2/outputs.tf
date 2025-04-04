output "bastion_id" {
  description = "ID of the Bastion Host"
  value       = aws_instance.bastion.id
}

output "private_instance_ids" {
  description = "IDs of the private instances"
  value       = aws_instance.private_servers[*].id
}

output "key_name" {
  description = "The name of the SSH key pair"
  value       = aws_key_pair.terraform_key.key_name
}