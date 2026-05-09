module "vpc" {
  source = "./modules/vpc"

  name = "demo-eks-vpc"
  cidr = "10.10.0.0/16"
}
