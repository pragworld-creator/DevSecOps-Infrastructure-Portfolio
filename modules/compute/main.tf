data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_lb" "alb" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    name = "${var.environment}-web-alb"
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "${var.environment}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    name = "${var.environment}-alb-tg"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_launch_template" "web-lt" {
  name_prefix   = "${var.environment}-web-lt-"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.ec2_sg_id]
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  user_data            = filebase64("${path.module}/userdata.sh")
  tags = {
    name = "${var.environment}-web-lt"
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name             = "${var.environment}-web-asg"
  max_size         = 2
  min_size         = 1
  desired_capacity = var.asg_desired_capacity
  launch_template {
    id      = aws_launch_template.web-lt.id
    version = "$Latest"
  }
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [aws_lb_target_group.alb_target_group.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  lifecycle {
    create_before_destroy = true
  }
}

