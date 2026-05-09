# Terraform AWS VPC Module

## Project Overview

This repository contains a reusable Terraform module for provisioning AWS VPC infrastructure. It's designed to simplify VPC creation with public and private subnets across multiple availability zones, NAT gateways, and proper tagging conventions.

**Purpose**: Enable teams to easily consume VPC infrastructure as code by importing this module from GitHub using git tags for versioning and stability.

## Use Case

This repository is intended to be used as a source Terraform module for other repositories (for example, deployment repositories). It exists primarily to:

- Provide a reusable, versioned VPC module that other repos can reference via git tags (for example `?ref=v1.0.0`).
- Serve as a testbed for modular design and examples so consumers can evaluate and adapt the module safely.

Consumers should reference specific tags and the module subdirectory (for example: `git::https://github.com/janchel/terraform-module-source.git//modules/vpc?ref=v1.0.0`) rather than unpinned branches in production.

## Design: Monorepo or Separate?

This repository is structured as a single module source (a separate module repository). It contains a `modules/` directory to organize module code and `examples/`/`tests/` to validate usage, but the intent is to publish and consume the VPC module as an independent, versioned module. If you need multiple independently released modules, consider a monorepo or separate repos per module depending on your release workflow and team preferences.

## Module Features

- **VPC Creation**: Automatically provisions a VPC with configurable CIDR blocks
- **Multi-AZ Support**: Creates subnets across multiple availability zones (default: 3 AZs)
- **Public & Private Subnets**: Automatically calculates and creates both public and private subnets
- **NAT Gateways**: Enables NAT gateways for private subnet internet access
- **Flexible Configuration**: Uses sensible defaults but allows full customization
- **Proper Tagging**: Implements AWS tagging best practices for organization and cost tracking

## Repository Structure

```
terraform-module-test/
├── modules/
│   └── vpc/                    # AWS VPC Module
│       ├── main.tf             # VPC and subnet configuration
│       ├── variables.tf        # Input variables with descriptions
│       ├── outputs.tf          # Output values for other modules
│       └── versions.tf         # Terraform and provider version requirements
│
├── examples/
│   ├── basic/                  # Basic usage example
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   └── advanced/               # Advanced usage example with custom config
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
│
├── tests/                      # Terratest test suite (Go)
│
├── Root Configuration Files:
│   ├── main.tf                 # Root module that uses vpc module
│   ├── variables.tf            # Root variables
│   ├── outputs.tf              # Root outputs
│   ├── provider.tf             # Provider configuration
│   └── versions.tf             # Version requirements
│
└── Documentation:
    ├── README.md               # This file
    ├── QUICKSTART.md           # Quick start guide
    └── CHANGELOG.md            # Version history
```

## Usage

### Basic Usage

```hcl
module "vpc" {
  source = "git::https://github.com/janchel/terraform-module-source.git//modules/vpc?ref=v1.0.0"

  name = "demo-eks-vpc"
  cidr = "10.10.0.0/16"
}
```

### Advanced Usage with Custom Subnets

```hcl
module "vpc" {
  source = "git::https://github.com/janchel/terraform-module-source.git//modules/vpc?ref=v1.0.0"

  name             = "demo-eks-vpc"
  cidr             = "10.10.0.0/16"
  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
  private_subnets = ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24"]

  public_subnet_tags = {
    Type = "Public"
  }

  private_subnet_tags = {
    Type = "Private"
  }
}
```

### Using Local Module (For Development)

If you're working locally in this repository:

```hcl
module "vpc" {
  source = "./modules/vpc"

  name = "demo-eks-vpc"
  cidr = "10.10.0.0/16"
}
```

### Using Outputs

```hcl
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "availability_zones" {
  value = module.vpc.availability_zones
}
```

## Input Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | string | `eks-vpc` | Name prefix for VPC and subnets |
| `cidr` | string | `10.10.0.0/16` | CIDR block for the VPC |
| `azs` | list(string) | `[]` | Availability zones to use (auto-detected if empty) |
| `public_subnets` | list(string) | `[]` | Public subnet CIDRs (auto-calculated if empty) |
| `private_subnets` | list(string) | `[]` | Private subnet CIDRs (auto-calculated if empty) |
| `public_subnet_tags` | map(string) | `{}` | Additional tags for public subnets |
| `private_subnet_tags` | map(string) | `{}` | Additional tags for private subnets |

## Output Values

| Output | Description |
|--------|-------------|
| `vpc_id` | The ID of the created VPC |
| `public_subnets` | List of public subnet IDs |
| `private_subnets` | List of private subnet IDs |
| `public_subnet_objects` | Full public subnet objects from AWS provider |
| `availability_zones` | List of availability zones used |
| `nat_gateway_ids` | List of NAT Gateway IDs |
| `nat_gateway_public_ips` | List of NAT Gateway public IP addresses |

## Module Dependencies

This module wraps the official Terraform AWS VPC module and requires:

- **Terraform**: >= 1.15
- **AWS Provider**: >= 6.0
- **terraform-aws-modules/vpc/aws**: >= 3.0.0
- **AWS Region**: ap-northeast-1 (Tokyo) by default

## Git Tagging and Versioning

### Why Git Tags?

Git tags enable:

### Semantic Versioning

This project follows [Semantic Versioning](https://semver.org/):

## Step-by-Step Git Tagging Procedure

### Prerequisites

Before tagging, ensure you are in the repository root directory and have git configured:

```bash
cd /home/granger/github/terraform-module-test
git config user.email "your-email@example.com"
git config user.name "Your Name"
```

## Module Release & Consumption (Recommended)

- Treat this repository as the module source only. Consumers (other repositories or teams) should reference released tags rather than deploying production infrastructure from the module repo itself — this makes upgrades intentional and reproducible.
- Create annotated (and optionally GPG-signed) tags for releases and push them to the remote:
  - `git tag -a v1.0.0 -m "v1.0.0: initial release"`
  - `git push origin v1.0.0`
- Add a `.terraform-version` file at the repo root to help `tfenv` users and document the supported Terraform version (for example, `1.15.0`).
- Commit example `.terraform.lock.hcl` files where appropriate to lock provider selections for examples and make `terraform init` reproducible for consumers.
- Tagging policy and consumption best practices:
  - Use semantic versioning and only change the `ref` in consumer repos when intentionally upgrading the module.
  - Prefer stable tags; do not use unpinned refs (branches/HEAD) in production.
  - Expose a `tags` variable and merge it with module defaults so consumers control tagging; avoid adding transient values (timestamps, CI IDs) in module defaults.
  - If you must avoid Terraform managing tags, consider `lifecycle { ignore_changes = [tags] }` (note: Terraform will stop managing tags for that resource).
- Continuous integration suggestions:
  - Add CI to run `terraform fmt`, `terraform validate`, and optionally `terraform init`/`plan` on PRs.
  - Optionally create a GitHub Actions workflow to create a GitHub Release when a tag is pushed.
- Consider publishing to the Terraform Registry for discoverability; registry publishing allows consumers to use `source = "namespace/name/provider"` and `version = "x.y.z"`.

### Step 1: Prepare Your Changes

Make any required modifications to the module files:

```bash
# Edit module files as needed
vim vpc/main.tf
vim vpc/variables.tf
vim vpc/outputs.tf
```

### Step 2: Commit Your Changes

Stage and commit your changes:

```bash
# Stage all changes
git add .

# Commit with descriptive message
git commit -m "Add VPC module with multi-AZ support"
```

**Commit Message Guidelines**:
- Use clear, descriptive messages
- Start with present tense verb (Add, Fix, Update, etc.)
- Reference any related issues: `Fix #123`
- Examples:
  - ✅ `Add NAT gateway support and outputs`
  - ✅ `Fix subnet CIDR calculation logic`
  - ❌ `update stuff`

### Step 3: Create a Git Tag

Create an annotated git tag (recommended over lightweight tags):

```bash
# Create tag with version v1.0.0
git tag -a v1.0.0 -m "Initial VPC module release"

# View the tag
git tag -l
git show v1.0.0
```

**Tag Naming Convention**:
- Always use `v` prefix: `v1.0.0`
- No spaces or special characters
- Follow semantic versioning

### Step 4: Push Tag to Remote Repository

Push the tag to GitHub:

```bash
# Push specific tag
git push origin v1.0.0

# Or push all tags
git push origin --tags
```

Verify tag in GitHub:
```bash
# List all remote tags
git ls-remote --tags origin
```

### Step 5: Update and Release Subsequent Versions

For the next release:

```bash
# Make your changes
vim vpc/main.tf

# Commit the changes
git add .
git commit -m "Update: Add enable_nat_gateway variable"

# Create new tag with incremented version
git tag -a v1.1.0 -m "Add configurable NAT gateway option"

# Push the tag
git push origin v1.1.0
```

## Complete Git Workflow Example

Here's a complete example of tagging a new VPC module release:

```bash
# 1. Navigate to repository
cd /home/granger/github/terraform-module-test

# 2. Configure git (if not already done)
git config user.email "devops@company.com"
git config user.name "DevOps Team"

# 3. Check git status
git status

# 4. Stage and commit changes
git add vpc/
git commit -m "feat: Add AWS VPC module with multi-AZ and NAT gateway support"

# 5. Create annotated tag
git tag -a v1.0.0 -m "Initial release: VPC module with public/private subnets across 3 AZs"

# 6. Verify tag
git show v1.0.0

# 7. Push changes and tag to remote
git push origin main
git push origin v1.0.0

# 8. Verify on remote
git ls-remote --tags origin
```

## Using Tagged Versions in Your Infrastructure Code

Once tagged, other teams can consume the module at specific versions:

### Using Specific Version

```hcl
module "prod_vpc" {
  source = "git::https://github.com/janchel/terraform-module-source.git//modules/vpc?ref=v1.0.0"
  
  name = "demo-eks-vpc"
  cidr = "10.10.0.0/16"
}
```

### Using Latest Minor/Patch Version

```hcl
# Get latest v1.x.x version
source = "git::https://github.com/janchel/terraform-module-source.git//modules/vpc?ref=v1"
```

### Using Latest Version

```hcl
# Get absolute latest (not recommended for production)
source = "git::https://github.com/janchel/terraform-module-source.git//modules/vpc"
```

## Module Workflow Checklist

Use this checklist when preparing a new module version release:

- [ ] All changes are tested locally with `terraform plan` and `terraform apply`
- [ ] Module documentation in README.md is updated
- [ ] Input variables have descriptions
- [ ] Outputs are documented
- [ ] Changes follow semantic versioning principles
- [ ] Git commit message is descriptive
- [ ] Tag annotation message clearly describes changes
- [ ] Tag follows `vX.Y.Z` format
- [ ] Pushed both commits and tags: `git push origin main --tags`
- [ ] Verified tag on remote: `git ls-remote --tags origin`

## Best Practices
Even though the VPC module is unlikely to change often, versioning still matters. Versioned releases (annotated tags) provide reproducible, auditable infrastructure, make rollbacks safe, and give consumers confidence to pin a stable interface. Maintain a short `CHANGELOG.md`, create annotated (or signed) tags for releases, and use CI to run validation and optionally publish releases so updates are intentional and discoverable.

### 1. Always Use Tagged Versions in Production

```hcl
# ✅ Good: Pinned to specific version
source = "git::https://github.com/org/repo.git//vpc?ref=v1.0.0"

# ❌ Bad: Unpinned, gets latest on every apply
source = "git::https://github.com/org/repo.git//vpc"

# ❌ Bad: Using branch, can break unexpectedly
source = "git::https://github.com/org/repo.git//vpc?ref=main"
```

### 2. Increment Versions Appropriately

```bash
# Major version: Breaking changes
git tag -a v2.0.0 -m "BREAKING: Removed deprecated variables"

# Minor version: New features, backward compatible
git tag -a v1.1.0 -m "feat: Add enable_nat_gateway variable"

# Patch version: Bug fixes only
git tag -a v1.0.1 -m "fix: Correct subnet CIDR calculation"
```

### 3. Always Use Annotated Tags

```bash
# ✅ Good: Annotated tag with message
git tag -a v1.0.0 -m "Release message here"

# ❌ Bad: Lightweight tag (no metadata)
git tag v1.0.0
```

### 4. Test Before Tagging

```bash
# Always test the module before creating a tag
terraform init
terraform plan
terraform validate

# Only tag after successful validation
git tag -a v1.0.0 -m "Tested and validated"
```

### 5. Document Breaking Changes

When making version 2.0 or other major updates:

```markdown
## v2.0.0 - BREAKING CHANGES

- **Removed**: `enable_nat_gateway` variable (now always enabled)
- **Changed**: `subnet_tags` variable renamed to `public_subnet_tags` and `private_subnet_tags`
- **Migration**: See UPGRADE.md for migration guide
```

## Troubleshooting

### Tag Already Exists

```bash
# List existing tags
git tag -l

# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0

# Create new tag
git tag -a v1.0.0 -m "Updated message"
```

### Tag Push Failed

```bash
# Ensure all commits are pushed first
git push origin main

# Then push tags
git push origin --tags
```

### Using Wrong Tag in Module

```bash
# See what Git thinks the current version is
terraform console
> ...

# Update source reference to correct tag
# Then run terraform init to download correct version
terraform init
```

## Contributing

When contributing changes to this module:

1. Make code changes
2. Test thoroughly locally
3. Create a commit with clear message
4. Create appropriate version tag
5. Push both commit and tag to remote
6. Update documentation if applicable

## Questions or Issues?

- Create an issue on GitHub
- Document the problem clearly
- Include Terraform version and error messages
- Provide example code that reproduces the issue

## Further Reading

- [Terraform Module Documentation](https://www.terraform.io/language/modules)
- [Semantic Versioning](https://semver.org/)
- [Git Tagging Guide](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
- [Terraform AWS VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws)

---

**Last Updated**: May 2026  
**Module Version**: v1.0.0  
**Terraform Version**: >= 1.15  
**AWS Provider**: >= 6.0  
**AWS Region**: ap-northeast-1 (Tokyo)
