# Amazon EBS CSI Driver Module

This module installs the Amazon EBS CSI driver as an EKS managed addon and
creates the IAM role used by the driver's controller through IAM Roles for
Service Accounts (IRSA).

## Usage

```hcl
module "ebs_csi" {
  source = "./modules/eks_addons/ebs_csi"

  cluster_name      = module.eks.cluster_name
  cluster_version   = var.cluster_version
}
```

## Inputs

| Name | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `cluster_name` | `string` | Yes | none | Name of the EKS cluster. |
| `cluster_version` | `string` | Yes | none | Kubernetes version of the EKS cluster. Used to select a compatible addon version. |
| `resolve_conflicts_on_create` | `string` | No | `OVERWRITE` | Conflict behavior when creating the addon. |
| `resolve_conflicts_on_update` | `string` | No | `PRESERVE` | Conflict behavior when updating the addon. |

## Requirements

- The EKS cluster and its IAM OIDC provider must already exist.
- The AWS provider must be configured with permission to manage EKS addons,
  IAM roles, policy attachments, and addon version data.
- The EBS CSI driver requires the `AmazonEBSCSIDriverPolicy` AWS managed policy.

The addon version is selected automatically with `aws_eks_addon_version` based
on the supplied Kubernetes version.