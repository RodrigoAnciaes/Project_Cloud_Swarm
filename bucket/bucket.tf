# Create an AWS S3 bucket resource named "bucket_terraform"
resource "aws_s3_bucket" "bucket_terraform" {
  bucket = "rodrigopatelli-terraform-state" # The name of the bucket
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket_terraform.id # The name of the bucket

  versioning_configuration {
    status = "Enabled" # Enable versioning
  }
}

# Create an S3 object in the bucket named "terraform.tfstate"
resource "aws_s3_object" "s3_object" {
  bucket        = aws_s3_bucket.bucket_terraform.id # The name of the bucket
  key           = "terraform.tfstate" # The name of the object
  force_destroy = true # Allow for forceful deletion of the object
}
