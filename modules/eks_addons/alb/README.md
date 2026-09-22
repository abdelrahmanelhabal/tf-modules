# AWS Load Balancer Controller Module

This module deploys the AWS Load Balancer Controller for an Amazon EKS cluster and configures the required IAM role and Kubernetes service account.

## What this module does

- Creates an IAM role for the AWS Load Balancer Controller using the cluster OIDC provider.
- Attaches the required AWS Load Balancer Controller IAM policy.
- Creates the Kubernetes service account annotation for the role.
- Applies the CRDs required by the controller.
- Installs the AWS Load Balancer Controller Helm chart in the `kube-system` namespace.

## Usage

```hcl
module "alb_controller" {
  source = "./modules/eks_addons/alb"

  eks_alb_role_name = "dev-aws-load-balancer-controller"
  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = "https://oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE"
  alb_version       = "1.7.1"
  vpc_id            = module.vpc.vpc_id
}
```

## Inputs

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `eks_alb_role_name` | `string` | Yes | Name of the IAM role for the ALB controller. |
| `cluster_name` | `string` | Yes | EKS cluster name used for tags and Helm values. |
| `oidc_provider_arn` | `string` | Yes | ARN of the cluster OIDC provider. |
| `oidc_provider_url` | `string` | Yes | Full OIDC issuer URL for the cluster. |
| `alb_version` | `string` | Yes | Version of the Helm chart to install. |
| `vpc_id` | `string` | Yes | VPC ID where the ALB resources should be created. |

## Outputs

| Name | Description |
| --- | --- |
| `iam_role_arn` | ARN of the IAM role used by the controller. |
| `iam_role_name` | Name of the IAM role used by the controller. |
| `helm_release_name` | Name of the Helm release that installs the controller. |

## Notes

- `oidc_provider_url` should be supplied as the full issuer URL, for example `https://oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE`.
- The controller is installed in the `kube-system` namespace and uses a pre-created Kubernetes service account named `aws-load-balancer-controller`.
- The module depends on `kubectl` being available in the environment where Terraform runs, because it applies the CRDs and service account manifest with `local-exec`.
- Ensure the cluster and VPC are already created before using this module.
