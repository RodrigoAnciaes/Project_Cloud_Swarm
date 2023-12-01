variable "alb_name" {
  description = "Name for the ALB"
  type        = string
  default     = "rodrigopatellipatelli_alb"
}

variable "ami_id" {
  description = "ID of the AMI to use for the EC2 instance"
  type        = string
  default     = "ami-0d86d19bb909a6c95"
}

variable "azs" {
  description = "Availability zones to use for the ALB"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cooldown" {
  description = "Cooldown period for the Auto Scaling Group"
  type        = number
  default     = 180
}

variable "db_host" {
  description = "Host for the DB instance"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "mydb"
}

variable "db_password" {
  description = "Password for the DB instance"
  type        = string
}

variable "db_username" {
  description = "Username for the DB instance"
  type        = string
}

variable "evaluation_periods" {
  description = "Number of evaluation periods for the CloudWatch alarm"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "internal" {
  description = "Whether the ALB is internal or not"
  type        = bool
  default     = false
}

variable "lb_type" {
  description = "Type of load balancer"
  type        = string
  default     = "application"
}

variable "metric_name" {
  description = "Name of the metric to monitor"
  type        = string
  default     = "CPUUtilization"
}

variable "namespace" {
  description = "Namespace of the metric to monitor"
  type        = string
  default     = "AWS/EC2" 
}

variable "period" {
  description = "Period of the metric to monitor"
  type        = number
  default     = 60
}

variable "region" {
  description = "Region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "statistic" {
  description = "Statistic of the metric to monitor"
  type        = string
  default     = "Average"
}

variable "target_group_name" {
  description = "Name for the target group"
  type        = string
  default     = "rodrigopatellipatelli_target_group"
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "timeout" {
  description = "Timeout for the target group"
  type        = number
  default     = 5
}
variable "adjustment_type" {
  description = "Type of adjustment for the Auto Scaling Group"
  type        = string
  default     = "ChangeInCapacity"
}