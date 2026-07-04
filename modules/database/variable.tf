variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "db_subnet_group_name" {
  description = "The subnet group created in the networking module"
  type        = string
}

variable "rds_sg_ids" {
  description = "The security group ID created in the security module"
  type        = list(string)
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "enterprisedb"
}

variable "db_username" {
  description = "Admin username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Admin password"
  type        = string
  sensitive   = true # This hides the password in your terminal, but visible in .tfstate file. Beaware!!
}