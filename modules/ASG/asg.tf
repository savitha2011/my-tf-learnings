#The launch template defines the configuration of the EC2 instances that the Auto Scaling Group will use
resource "aws_launch_template" "asg_template" {
  name          = "asg-template"
  image_id      = "ami-0df8c184d5f6ae949"
  instance_type = "t2.micro"
  # subnet_id              = var.subnetid
  vpc_security_group_ids = [var.websg]
  #map_public = true
  #security_group_names1   = [aws_security_group1.web_sg1] ----Need to cl
  user_data = filebase64("${path.module}/script.sh")

  lifecycle {
    create_before_destroy = true
  }
}

#Define the Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  min_size         = 1
  max_size         = 5
  #vpc_zone_identifier = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  vpc_zone_identifier = [var.subnetid, var.subnetid2]
  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  wait_for_capacity_timeout = "0"

  tag {
    key                 = "Name"
    value               = "AutoScalingInstance"
    propagate_at_launch = true
  }
}

#Define the Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.websg]
  subnets            = [var.subnetid, var.subnetid2]
  #depends_on                 = [aws_internet_gateway.igw.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "target_group" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpcid
  tags = {
    Name = "ALB_targetgp"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
  tags = {
    Name = "alb_listener"
  }
}

#Attach the Auto Scaling Group to the Load Balancer
#resource "aws_autoscaling_attachment" "asg_attachment" {
#autoscaling_group_name = aws_autoscaling_group.asg.name
#alb_target_group_arn   = aws_lb_target_group.target_group.arn
