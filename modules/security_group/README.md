# Security Group Module

This module creates one or more Amazon EC2 security groups and attaches the required ingress and egress rules from a structured map definition.

## What this module does

- Creates security groups in a given VPC.
- Applies shared tags to every group.
- Supports multiple ingress and egress rules per group.
- Supports IPv4, IPv6, self-referential, and source-security-group-based rules.

## Usage

```hcl
module "security_group" {
  source = "./modules/security_group"

  tags = {
    Environment = "dev"
    Project     = "example"
  }

  security_groups = {
    web = {
      description = "Security group for web traffic"
      vpc_id      = module.vpc.vpc_id
      ingress = [
        {
          description = "Allow HTTP from anywhere"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "Allow HTTPS from anywhere"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress = [
        {
          description = "Allow all outbound traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}
```

## Inputs

| Name | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `security_groups` | `map(object(...))` | Yes | none | Map of security groups, each with a description, VPC ID, ingress rules, and egress rules. |
| `tags` | `map(string)` | No | `{}` | Common tags added to all security groups. |

### Rule object fields

Each ingress/egress rule supports the following fields:

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `description` | `string` | Yes | Rule description. |
| `from_port` | `number` | Yes | Starting port for the rule. |
| `to_port` | `number` | Yes | Ending port for the rule. |
| `protocol` | `string` | Yes | Protocol such as `tcp`, `udp`, or `-1`. |
| `cidr_blocks` | `list(string)` | No | IPv4 CIDR blocks for the rule. |
| `ipv6_cidr_blocks` | `list(string)` | No | IPv6 CIDR blocks for the rule. |
| `self` | `bool` | No | Whether to allow traffic from the same security group. |
| `source_security_group_id` | `string` | No | Source security group ID when referencing another group. |

## Outputs

| Name | Description |
| --- | --- |
| `security_group_ids` | Map of created security group IDs keyed by group name. |
| `security_group_names` | Map of created security group names keyed by group name. |

## Notes

- Only one of `cidr_blocks`, `ipv6_cidr_blocks`, `self`, or `source_security_group_id` should be used for a given rule depending on the access pattern.
- For all rules, the security group name in the map is used as the `Name` tag and as the lookup key for the created security group.
