# Define an AWS EC2 instance resource named "ec2_locust"
resource "aws_instance" "ec2_locust" {
    # Use the AMI ID specified in the "var" variable
    ami                         = var.ami_id

    # Set the instance type based on the value in the "var" variable
    instance_type               = var.instance_type

    # Associate the EC2 instance with the security group defined as "locust_sg"
    vpc_security_group_ids      = [aws_security_group.locust_sg.id]

    # Specify the subnet ID for the EC2 instance
    subnet_id                   = module.vpc.public_subnets[0]

    # Enable the EC2 instance to have a public IP address
    associate_public_ip_address = true
    
    # Provide user data to the EC2 instance by encoding a template file
    user_data = base64encode(templatefile("locust/user_data.tftpl", {
        lb_endpoint = aws_alb.alb.dns_name
    }))

    # Add tags to the EC2 instance for identification
    tags = {
        Name = "ec2-locust"
    }
}