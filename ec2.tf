/**
 * This Terraform file defines the infrastructure for an EC2 instance in AWS.
 * It creates an AWS key pair, launch template, autoscaling group, autoscaling policies,
 * CloudWatch alarms, and an autoscaling attachment.
 * 
 * Resources:
 * - aws_key_pair: Creates an AWS key pair for SSH access to the EC2 instances.
 * - aws_launch_template: Defines the launch template for the EC2 instances.
 * - aws_autoscaling_group: Creates an autoscaling group for the EC2 instances.
 * - aws_autoscaling_policy: Defines autoscaling policies for scaling up and down the EC2 instances.
 * - aws_cloudwatch_metric_alarm: Creates CloudWatch alarms for monitoring CPU utilization of the EC2 instances.
 * - aws_autoscaling_attachment: Attaches the autoscaling group to an Application Load Balancer target group.
 * 
 * Inputs:
 * - var.ami_id: The ID of the Amazon Machine Image (AMI) to use for the EC2 instances.
 * - var.instance_type: The type of EC2 instance to launch.
 * - var.db_name: The name of the database.
 * - var.db_username: The username for accessing the database.
 * - var.db_password: The password for accessing the database.
 * - var.adjustment_type: The type of adjustment for autoscaling policies.
 * - var.cooldown: The cooldown period for autoscaling policies.
 * - var.evaluation_periods: The number of evaluation periods for CloudWatch alarms.
 * - var.metric_name: The name of the metric for CloudWatch alarms.
 * - var.namespace: The namespace for CloudWatch alarms.
 * - var.period: The period for CloudWatch alarms.
 * - var.statistic: The statistic for CloudWatch alarms.
 * 
 * Outputs:
 * - None
 */


# ----------------------------- Variables -----------------------------

resource "aws_key_pair" "key_pair" {
  key_name   = "rodrigopatelli-key-pair"
  public_key = file("../rodrigo_kp.pub")
}


# ----------------------------- Launch Template -----------------------------

resource "aws_launch_template" "launch_template" {
  name_prefix                 = "rodrigopatelli-launch-template"
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key_pair.key_name
  user_data = base64encode(templatefile("user_data.tftpl", {db_host=aws_db_instance.rds_instance.address, db_name = var.db_name, db_username = var.db_username, db_password = var.db_password, db_port = aws_db_instance.rds_instance.port}))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "rodrigopatelli-launch-template"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = module.vpc.public_subnets[0]
    security_groups             = [aws_security_group.ec2_sg.id]
  }
}

# ----------------------------- Autoscaling Group -----------------------------

resource "aws_autoscaling_group" "asg" {
  name                 = "rodrigopatelli-asg"
  desired_capacity     = 2
  min_size             = 2
  max_size             = 6
  vpc_zone_identifier  = module.vpc.public_subnets
  target_group_arns    = [aws_alb_target_group.alb_tg.arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}

# ----------------------------- Autoscaling Policies -----------------------------

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "rodrigopatelli-scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = var.adjustment_type # ChangeInCapacity
  cooldown               = var.cooldown # 3 minutes
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "rodrigopatelli-scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = var.adjustment_type # ChangeInCapacity
  cooldown               = var.cooldown # 3 minutes
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# ------------------------------ Autoscaling Attachment ------------------------------

# The aws_autoscaling_attachment resource is used to attach an Auto Scaling Group (ASG) 
# to a target group in an Application Load Balancer (ALB).
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn   = aws_alb_target_group.alb_tg.arn
}


# ------------------------------ CloudWatch Alarms ------------------------------

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "rodrigopatelli-high-cpu-alarm"  # Name of the alarm
  comparison_operator = "GreaterThanThreshold"          # Operator used for comparison
  evaluation_periods  = var.evaluation_periods          # Number of evaluation periods
  metric_name         = var.metric_name                 # Name of the metric to monitor
  namespace           = var.namespace                   # Namespace of the metric
  period              = var.period                      # Length of each period in seconds
  statistic           = var.statistic                   # Statistic to apply to the metric
  threshold           = 20                              # Threshold value for the alarm
  alarm_description   = "This metric monitors ec2 high cpu utilization"  # Description of the alarm
  alarm_actions       = [aws_autoscaling_policy.scale_up_policy.arn]     # Actions to take when the alarm is triggered
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name  # Dimension for the alarm
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "rodrigopatelli-low-cpu-alarm"   # Name of the alarm
  comparison_operator = "LessThanThreshold"              # Operator used for comparison
  evaluation_periods  = var.evaluation_periods           # Number of evaluation periods
  metric_name         = var.metric_name                  # Name of the metric to monitor
  namespace           = var.namespace                    # Namespace of the metric
  period              = var.period                       # Length of each period in seconds
  statistic           = var.statistic                    # Statistic to apply to the metric
  threshold           = 10                               # Threshold value for the alarm
  alarm_description   = "This metric monitors ec2 low cpu utilization"  # Description of the alarm
  alarm_actions       = [aws_autoscaling_policy.scale_down_policy.arn]  # Actions to take when the alarm is triggered
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name  # Dimension for the alarm
  }
}