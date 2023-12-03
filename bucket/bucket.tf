# Create an AWS S3 bucket resource named "bucket_terraform"
resource "aws_s3_bucket" "bucket_terraform" {
  bucket = "rodrigopatelli-terraform-state" # The name of the bucket
}

