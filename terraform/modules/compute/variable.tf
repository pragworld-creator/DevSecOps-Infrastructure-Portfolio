variable "environment" {
  description = "The name of the environment(dev/prod)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the compute resources will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs where ABL will be deployed"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs where EC2 instances will be deployed"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The security group ID for the Application Load Balancer"
  type        = string
}

variable "ec2_sg_id" {
  description = "The security group ID for the EC2 instances"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile for SSM access"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type for the compute resources"
  type        = string
  default     = "t3.micro"
}

variable "asg_desired_capacity" {
  description = "The desired capacity of the Auto Scaling Group"
  type        = number
  default     = 2
}