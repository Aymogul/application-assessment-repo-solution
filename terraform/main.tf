provider "aws" {
  region = "eu-west-1"
}

terraform {

    backend "s3" {
      bucket = "ay-cloud-height-tf-bucket-state"
      region = "eu-west-1"
      key = "state/terraform.tfstate"
    }

}

# configure VPC with 6 subnets in three avaiablilty zones
# single NAT gatway and two route tables for public and private subnets + default route table
# one IGW

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "demo-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true

  tags = {
    Project = "Demo"
  }
}