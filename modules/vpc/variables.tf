variable "name" {
  description = "Name prefix for VPC and subnets"
  type        = string
  default     = "eks-vpc"
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "azs" {
  description = "Availability zones to use (optional)"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "Optional list of public subnet CIDRs. If empty, module will create them across AZs."
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "Optional list of private subnet CIDRs. If empty, module will create them across AZs."
  type        = list(string)
  default     = []
}

variable "public_subnet_tags" {
  description = "Optional tags to apply to all public subnets (merged with a default Name tag)."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Optional tags to apply to all private subnets (merged with a default Name tag)."
  type        = map(string)
  default     = {}
}
