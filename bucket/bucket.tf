# Create an AWS S3 bucket resource named "bucket_terraform"
resource "aws_s3_bucket" "bucket_terraform" {
  bucket = "ro-testepatelli-terraform-state" # The name of the bucket
}