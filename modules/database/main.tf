resource "aws_db_instance" "main" {
  allocated_storage      = 20 # 20GB of storage
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  
  db_subnet_group_name   = var.db_subnet_group_name
  
  vpc_security_group_ids = var.rds_sg_ids
  
  # High Availability: Deploys a standby in a different AZ
  multi_az               = true 
  
  # Security: Ensures the DB doesn't have a public IP
  publicly_accessible    = false
  
  # Cleanup: Allows us to delete the DB easily after this project
  skip_final_snapshot    = true

  tags = {
    Name = "${var.environment}-primary-db"
  }
}