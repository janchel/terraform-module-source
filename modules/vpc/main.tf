data "aws_availability_zones" "available" {}

locals {
  use_azs = length(var.azs) > 0 ? var.azs : slice(data.aws_availability_zones.available.names, 0, min(length(data.aws_availability_zones.available.names), 3))

  public_subnets_calc  = [for i in range(length(local.use_azs)) : cidrsubnet(var.cidr, 8, i)]
  private_subnets_calc = [for i in range(length(local.use_azs)) : cidrsubnet(var.cidr, 8, i + length(local.use_azs))]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.0.0"

  name = var.name
  cidr = var.cidr

  azs             = local.use_azs
  public_subnets  = length(var.public_subnets) > 0 ? var.public_subnets : local.public_subnets_calc
  private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : local.private_subnets_calc

  enable_nat_gateway = true

  # Best-practice tagging
  tags = {
    "Name" = var.name
  }

  # Tag subnets so their purpose is obvious (applied to each public/private subnet)
  public_subnet_tags  = merge({ "Name" = "${var.name}-public" }, var.public_subnet_tags)
  private_subnet_tags = merge({ "Name" = "${var.name}-private" }, var.private_subnet_tags)
}
