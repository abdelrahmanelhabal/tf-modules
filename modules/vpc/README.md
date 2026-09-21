# VPC Module

This Terraform module creates a VPC with public and private subnets, an internet gateway, optional NAT gateway, and route tables for both subnet groups.

## Features

- Creates a VPC with DNS support and hostname support enabled
- Creates one or more public subnets
- Creates one or more private subnets
- Creates an internet gateway for public access
- Creates route tables and associations for public/private traffic
- Optionally creates a NAT gateway for private subnet outbound internet access
- Adds EKS tagging metadata when a cluster name is provided

## Usage

```hcl
module "vpc" {
  source = "./vpc"

  name        = "dev-vpc"
  cidr_block  = "10.0.0.0/16"
  cluster_name = "dev-cluster"

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]

  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24",
  ]

  azs = [
    "us-east-1a",
    "us-east-1b",
  ]

  enable_nat_gateway = true

  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
```

## Inputs

| Name | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `cluster_name` | `string` | Yes | `null` | Name of the EKS cluster used for Kubernetes tags. |
| `cidr_block` | `string` | Yes | none | CIDR block for the VPC. |
| `name` | `string` | Yes | none | Name used for resource tags and naming. |
| `tags` | `map(string)` | No | `{}` | Common tags applied to VPC and subnets. |
| `public_subnets` | `list(string)` | Yes | none | CIDR blocks for public subnets. |
| `private_subnets` | `list(string)` | Yes | none | CIDR blocks for private subnets. |
| `azs` | `list(string)` | Yes | none | Availability zones for the subnets. |
| `enable_nat_gateway` | `bool` | No | `false` | Whether to create a NAT gateway for private subnets. |

## Outputs

| Name | Description |
| --- | --- |
| `vpc_id` | ID of the created VPC. |
| `public_subnet_ids` | IDs of the public subnets in the VPC. |
| `private_subnet_ids` | IDs of the private subnets in the VPC. |

## Notes

- `public_subnets`, `private_subnets`, and `azs` should have matching lengths so each subnet is created in the correct availability zone.
- When `cluster_name` is set, this module adds Kubernetes tagging for the cluster to the subnets.
- Setting `enable_nat_gateway = true` creates a single NAT gateway in the first public subnet.
