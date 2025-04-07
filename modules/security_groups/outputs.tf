output "alb_sg_id" {
  description = "The security group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "bastion_sg_id" {
  description = "The security group ID for the Bastion host"
  value       = aws_security_group.bastion_sg.id
}

output "private_sg_id" {
  description = "The security group ID for private instances"
  value       = aws_security_group.private_sg.id
}
