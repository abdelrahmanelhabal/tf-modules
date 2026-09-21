# EKS Module

This Terraform module creates an Amazon EKS control plane with secrets encryption, an IAM OIDC provider, and the AWS-managed `vpc-cni`, `kube-proxy`, and `coredns` add-ons.

## Prerequisites

- Terraform with the AWS and TLS providers configured.
- AWS credentials with permission to create EKS, IAM, KMS, and add-on resources.
- The AWS CLI installed and authenticated. The module updates the local kubeconfig after the cluster is created.
- At least two suitable subnets in the target VPC. Pass the subnet IDs through `subnets_ids`.
- Security group IDs for the EKS control plane through `eks_sg_ids`.

## Usage

```hcl
module "eks" {
  source = "./eks"

  cluster_name          = "dev-eks"
  cluster_version       = "1.31"
  eks_role_name         = "dev-eks-control-plane"
  env                   = "dev"
  infrastructure_region = "us-east-1"

  subnets_ids = [
    "subnet-0123456789abcdef0",
    "subnet-0fedcba9876543210",
  ]

  eks_sg_ids              = ["sg-0123456789abcdef0"]
  endpoint_private_access = true
  endpoint_public_access  = true

  tags = {
    Project = "platform"
  }
}
```

The `cluster_version` must be supported by EKS in the selected AWS region. The add-on versions are selected by AWS for that Kubernetes version.

## Inputs

| Name | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `eks_role_name` | `string` | Yes | none | IAM role name for the EKS control plane. |
| `env` | `string` | Yes | none | Environment name used in tags. |
| `tags` | `map(string)` | No | `{}` | Additional tags applied to the cluster. |
| `cluster_name` | `string` | Yes | none | EKS cluster name. |
| `cluster_version` | `string` | Yes | none | Kubernetes version for the cluster and add-ons. |
| `subnets_ids` | `list(string)` | Yes | none | Subnet IDs for the EKS control plane. |
| `eks_sg_ids` | `list(string)` | Yes | none | Security group IDs for the EKS control plane. |
| `endpoint_private_access` | `bool` | Yes | none | Enables the private Kubernetes API endpoint. |
| `endpoint_public_access` | `bool` | Yes | none | Enables the public Kubernetes API endpoint. |
| `infrastructure_region` | `string` | Yes | none | AWS region used by the kubeconfig update command. |
| `eks_addon_creation_conflict_behavior` | `string` | No | `OVERWRITE` | Conflict behavior when creating add-ons. |
| `eks_addon_update_conflict_behavior` | `string` | No | `PRESERVE` | Conflict behavior when updating add-ons. |

## Outputs

| Name | Description |
| --- | --- |
| `cluster_name` | Name of the EKS cluster. |
| `cluster_endpoint` | Kubernetes API server endpoint. |
| `cluster_certificate_authority_data` | Base64-encoded cluster certificate authority data. |
| `cluster_role_arn` | EKS control-plane IAM role ARN. |
| `oidc_provider_arn` | IAM OIDC provider ARN for the cluster. |

## Notes

- The module creates a KMS key for EKS secrets encryption. The key has the default KMS deletion window of 40 days.
- The `vpc-cni` add-on receives an IRSA role using the cluster OIDC provider.
- The cluster resource runs `aws eks update-kubeconfig` locally. This requires the AWS CLI and changes the current user's kubeconfig.