variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-northeast-1"
}

provider "aws" {
  region = var.aws_region
}
