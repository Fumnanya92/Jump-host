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

output "bastion_instance_public_ip" {
  description = "The public IP of the Bastion Host instance"
  value       = aws_instance.bastion.public_ip
}

output "private_server_instance_ip" {
  description = "The IDs of the Private Server instances"
  value       = aws_instance.private_servers[*].private_ip
}

locals {
  inventory_content = templatefile("${path.module}/ansible/inventory.tpl", {
    bastion_ip  = aws_instance.bastion.public_ip
    private_ips = [for i in aws_instance.private_servers : i.private_ip]
  })
}

