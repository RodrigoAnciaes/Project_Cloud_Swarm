# ------------------------------ Application Load Balancer ------------------------------ #

# This resource block defines an Application Load Balancer (ALB) in AWS. The ALB distributes incoming traffic across multiple targets, such as EC2 instances, based on routing rules and health checks.

resource "aws_alb" "alb" {
  name                             = "rodrigopatelli-alb"  # Specify the name of the ALB
  internal                         = false  # Set to true if the ALB is internal, false if it's public
  load_balancer_type               = "application"  # Specify the type of the load balancer
  security_groups                  = [aws_security_group.alb_sg.id]  # Specify the security groups associated with the ALB
  subnets                          = module.vpc.public_subnets  # Specify the subnets where the ALB will be deployed
  enable_deletion_protection       = false  # Set to true to enable deletion protection for the ALB
  enable_cross_zone_load_balancing = true  # Set to true to enable cross-zone load balancing for the ALB

  tags = {
    Name = "rodrigopatelli-alb"  # Specify tags for the ALB resource
  }
}

# Create a target group for the ALB
resource "aws_alb_target_group" "alb_tg" {
  name     = "rodrigopatelli-alb-tg"  # Specify the name of the target group
  port     = 80  # Specify the port on which the target group will listen
  protocol = "HTTP"  # Specify the protocol used by the target group
  vpc_id   = module.vpc.vpc_id  # Specify the ID of the VPC where the target group will be created
  
  # Configure health checks for the target group
  health_check {
    healthy_threshold   = 2  # Specify the number of consecutive successful health checks required to consider a target healthy
    unhealthy_threshold = 2  # Specify the number of consecutive failed health checks required to consider a target unhealthy
    timeout             = 20  # Specify the amount of time, in seconds, during which no response means a failed health check
    interval            = 60  # Specify the interval, in seconds, between health checks
    path                = "/docs"  # Specify the path to use for health checks
  }

  tags = {
    Name = "rodrigopatelli-alb-tg"  # Specify tags for the target group
  }
}

# Create a listener for the ALB
resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn  # Specify the ARN of the ALB
  port              = "80"  # Specify the port on which the listener will listen
  protocol          = "HTTP"  # Specify the protocol used by the listener

  # Configure the default action for the listener
  default_action {
    target_group_arn = aws_alb_target_group.alb_tg.arn  # Specify the ARN of the target group to forward traffic to
    type             = "forward"  # Specify the action type as "forward"
  }
}
