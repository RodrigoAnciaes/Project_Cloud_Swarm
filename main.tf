terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"  // Specifies the source of the AWS provider plugin
      version = ">= 5.0.0"       // Specifies the minimum version of the AWS provider plugin required
    }
  }
  required_version = ">= 1.2.0"  // Specifies the minimum version of Terraform required
  backend "s3" {
    bucket         = "rodrigopatelli-terraform-state"  // Specifies the name of the S3 bucket to store the Terraform state file
    key            = "terraform.tfstate"               // Specifies the name of the Terraform state file
    region         = "us-east-1"                       // Specifies the AWS region where the S3 bucket is located
    encrypt        = true                              // Enables encryption of the Terraform state file
  }
}

provider "aws" {
  region = var.region  // Specifies the AWS region to use for the provider
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"  // Specifies the source of the VPC module

  name = "rodrigopatelli-vpc"  // Specifies the name of the VPC
  cidr = "172.31.0.0/16"      // Specifies the CIDR block for the VPC
  azs = var.azs               // Specifies the availability zones for the VPC

  // Define CIDR blocks for your private subnets
  private_subnets = ["172.31.0.0/26", "172.31.0.64/26"]

  // Define CIDR blocks for your public subnets
  public_subnets = ["172.31.0.128/26", "172.31.0.192/26"]

  enable_nat_gateway = true   // Enables the creation of a NAT gateway
  enable_vpn_gateway = true   // Enables the creation of a VPN gateway

  tags = {
    Terraform = "true"
    Environment = "Development"
    Project = "rodrigopatelli"
  }
}
