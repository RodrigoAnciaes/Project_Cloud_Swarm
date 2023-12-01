# Output for the Locust endpoint
output "locust_endpoint" {
  value = "${aws_instance.ec2_locust.public_dns}:8089"
}

# Output for the ALB endpoint
output "alb_endpoint" {
  value = "${aws_alb.alb.dns_name}/docs"
}