provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  name             = "demo-eks-vpc"
  cidr             = "10.10.0.0/16"
  azs              = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  public_subnet_tags = {
    Type        = "Public"
    Environment = var.environment
  }

  private_subnet_tags = {
    Type        = "Private"
    Environment = var.environment
  }
}
