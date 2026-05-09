# Examples Directory

This directory contains example configurations for using the VPC module.

## Examples Included

### 1. Basic Example (`basic/`)

The simplest way to use the module with default values:

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name = "demo-eks-vpc"
  cidr = "10.10.0.0/16"
}
```

**Run the example:**
```bash
cd examples/basic
terraform init
terraform plan
terraform apply
```

**What gets created:**
- 1 VPC with CIDR block `10.10.0.0/16`
- 3 public subnets (one per AZ)
- 3 private subnets (one per AZ)
- 3 NAT Gateways (one per public subnet)
- Internet Gateway
- Route tables for public and private subnets

### 2. Advanced Example (`advanced/`)

More control with custom subnets and additional tags:

```hcl
module "vpc" {
  source = "../../modules/vpc"

  name             = "demo-eks-vpc"
  cidr             = "10.10.0.0/16"
  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
  private_subnets = ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24"]

  public_subnet_tags = {
    "Type"        = "Public"
    "Environment" = "production"
  }

  private_subnet_tags = {
    "Type"        = "Private"
    "Environment" = "production"
  }
}
```

**Run the example:**
```bash
cd examples/advanced
terraform init
terraform plan
terraform apply
```

## How to Use These Examples

### Option 1: Using the examples locally (for testing/development)

```bash
cd examples/basic
terraform init
terraform plan
terraform apply
```

### Option 2: Creating your own deployment

1. **Create your own directory:**
   ```bash
   mkdir my-vpc-deployment
   cd my-vpc-deployment
   ```

2. **Reference the module from GitHub:**
   ```hcl
   module "vpc" {
    source = "git::https://github.com/janchel/terraform-module-source.git//modules/vpc?ref=v1.0.0"
     
     name = "demo-eks-vpc"
     cidr = "10.10.0.0/16"
   }
   ```

3. **Or reference the module locally (for development):**
   ```hcl
   module "vpc" {
     source = "../../modules/vpc"
     
     name = "demo-eks-vpc"
     cidr = "10.10.0.0/16"
   }
   ```

4. **Customize the variables for your use case:**
   - `name`: Give your VPC a meaningful name
   - `cidr`: Choose an appropriate CIDR block
   - `azs`: Select availability zones for your region
   - `public_subnets`: Define public subnet CIDRs
   - `private_subnets`: Define private subnet CIDRs
   - `*_subnet_tags`: Add custom tags

5. **Plan and apply:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Accessing Module Outputs

After applying, access the outputs in your code:

```hcl
# Get the VPC ID
aws_vpc = module.my_vpc.vpc_id

# Get subnet lists
public_subnets = module.my_vpc.public_subnets
private_subnets = module.my_vpc.private_subnets

# Get availability zones
azs = module.my_vpc.availability_zones

# Get NAT Gateway details
nat_ips = module.my_vpc.nat_gateway_public_ips
nat_ids = module.my_vpc.nat_gateway_ids
```

## Cleaning Up

To destroy the example infrastructure:

```bash
terraform destroy
```

When prompted, type `yes` to confirm.

## Troubleshooting

### AWS Credentials
Ensure your AWS credentials are configured:
```bash
aws configure
# Or use environment variables: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
```

### Region
Make sure the region in `provider "aws"` matches your intended deployment region.

### Terraform State
The `.terraform/` directory and `terraform.tfstate*` files are created locally. In production, store state remotely.

## Next Steps

- Review the [main README.md](../README.md) for detailed documentation
- Learn about [Semantic Versioning](https://semver.org/)
- Explore the module source code in `../modules/vpc/`
- Set up a remote state backend for production use


