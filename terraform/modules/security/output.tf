output "alb_sg_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb-sg.id
}

output "ec2_sg_id" {
  description = "The ID of the EC2 security group"
  value       = aws_security_group.ec2-sg.id
}

output "rds_sg_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds-sg.id
}

output "iam_instance_profile_name" {
  description = "The name of the IAM instance profile for SSM"
  value       = aws_iam_instance_profile.ssm_instance_profile.name
}

