variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-northeast-1"
}

# Note: VPC name and CIDR are hardcoded in main.tf to match aws-terraform-eks-terratest
# VPC Name: demo-eks-vpc
# VPC CIDR: 10.10.0.0/16
