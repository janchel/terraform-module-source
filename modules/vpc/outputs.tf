output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnet_objects" {
  description = "Forwarded list of public subnet objects from underlying module"
  value       = try(module.vpc.public_subnet_objects, [])
}

output "availability_zones" {
  description = "Availability zones used by the public subnets"
  value       = try(module.vpc.azs, distinct([for s in try(module.vpc.public_subnet_objects, []) : try(s.availability_zone, "")]))
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = try(module.vpc.natgw_ids, [])
}

output "nat_gateway_public_ips" {
  description = "List of NAT Gateway public IPs"
  value       = try(module.vpc.nat_public_ips, [])
}
