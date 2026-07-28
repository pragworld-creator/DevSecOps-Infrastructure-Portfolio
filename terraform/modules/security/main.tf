resource "aws_security_group" "alb-sg" {
    name        = "${var.environment}-alb-sg"
    vpc_id = var.vpc_id
     ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
     }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

     egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"] 
     }

     tags = {
    Name = "${var.environment}-alb-sg"
  }
}

resource "aws_security_group" "ec2-sg" {
    name        = "${var.environment}-ec2-sg"
    vpc_id = var.vpc_id
     ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb-sg.id]
     }

    # ingress ={
    #     from_port = 443
    #     to_port = 443
    #     protocol = "tcp"
    #     security_groups = [aws_security_group.alb-sg]
    # }

     egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"] 
     }

     tags = {
    Name = "${var.environment}-ec2-sg"
  }
}

resource "aws_security_group" "rds-sg" {
    name        = "${var.environment}-rds-sg"
    vpc_id = var.vpc_id
     ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.ec2-sg.id]
     }

     egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"] 
     }

     tags = {
    Name = "${var.environment}-rds-sg"
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "${var.environment}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-ssm-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.environment}-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name

  tags = {
    Name        = "${var.environment}-ssm-instance-profile"
    Environment = var.environment
  }
}