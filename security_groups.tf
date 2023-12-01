# Create an AWS security group for the EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "rodrigopatelli-ec2-sg"
  description = "Security group for EC2"
  vpc_id      = module.vpc.vpc_id

  # Allow incoming traffic on port 80 (HTTP) from the ALB security group
  ingress {
    from_port         = 80
    to_port           = 80
    protocol          = "TCP"
    security_groups   = [aws_security_group.alb_sg.id]
  }

  # Allow incoming traffic on port 22 (SSH) from any source
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add tags to the security group
  tags = {
    Name = "rodrigopatelli-ec2-sg"
  }
}

# Create an AWS security group for the RDS database
resource "aws_security_group" "rds_sg" {
  name        = "rodrigopatelli-rds-sg"
  description = "Security group for RDS"
  vpc_id      = module.vpc.vpc_id

  # Allow incoming traffic on port 3306 (MySQL) from the EC2 security group
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "TCP"
    security_groups   = [aws_security_group.ec2_sg.id]
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add tags to the security group
  tags = {
    Name = "rodrigopatelli-rds-sg"
  }
}

# Create an AWS security group for the Application Load Balancer (ALB)
resource "aws_security_group" "alb_sg" {
  name        = "rodrigopatelli-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  # Allow incoming traffic on port 80 (HTTP) from any source
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow incoming traffic on port 22 (SSH) from any source
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add tags to the security group
  tags = {
    Name = "rodrigopatelli-alb-sg"
  }
}

# Create an AWS security group for Locust load testing tool
resource "aws_security_group" "locust_sg" {
  name        = "rodrigopatelli-locust-sg"
  description = "Security group for Locust"
  vpc_id      = module.vpc.vpc_id

  # Allow all incoming traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add tags to the security group
  tags = {
    Name = "rodrigopatelli-locust-sg"
  }
}
