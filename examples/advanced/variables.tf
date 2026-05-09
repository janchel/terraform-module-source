variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-northeast-1"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnets" {
  description = "Public subnet CIDRs (auto-calculated from 10.10.0.0/16)"
  type        = list(string)
  default     = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs (auto-calculated from 10.10.0.0/16)"
  type        = list(string)
  default     = ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24"]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}
