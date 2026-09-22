# Argo CD Module

This module installs Argo CD on an Amazon EKS cluster using the official Argo Helm chart and creates an ALB ingress for the Argo CD server.

## What this module does

- Installs the `argo-cd` Helm release in the `argocd` namespace.
- Creates the namespace if it does not already exist.
- Renders an ALB ingress manifest for Argo CD using the supplied networking values.
- Applies the ingress manifest with `kubectl`.
- Allows scaling of the server, repo server, controller, and application set replicas through variables.

## Usage

```hcl
module "argocd" {
  source = "./modules/eks_addons/argo_cd"

  helm_version                          = "5.46.7"
  node_group_name                       = module.eks_nodegroup.node_group_name
  lb_security_group1                    = "sg-11111111111111111"
  lb_security_group2                    = "sg-22222222222222222"
  lb_subnet1                            = "subnet-11111111"
  lb_subnet2                            = "subnet-22222222"
  lb_domain_name                        = "argocd.example.com"
  lb_scheme                             = "internet-facing"
  ingress_path                          = "/"
  ingress_group_name                    = "argocd-alb"
  server_replica_count                  = 1
  repo_server_replica_count             = 1
  controller_replica_count              = 1
  application_set_controller_replica_count = 1
  enable_redis_hpa                     = false
}
```

## Inputs

| Name | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `helm_version` | `string` | Yes | none | Version of the Argo CD Helm chart. |
| `node_group_name` | `string` | Yes | none | EKS node group name used as a dependency for installation. |
| `lb_security_group1` | `string` | Yes | none | First security group for the Argo CD ALB ingress. |
| `lb_security_group2` | `string` | Yes | none | Second security group for the Argo CD ALB ingress. |
| `lb_subnet1` | `string` | Yes | none | First subnet that the ALB should use. |
| `lb_subnet2` | `string` | Yes | none | Second subnet that the ALB should use. |
| `lb_domain_name` | `string` | Yes | none | DNS host name used in the ingress rule. |
| `lb_scheme` | `string` | Yes | none | ALB scheme such as `internal` or `internet-facing`. |
| `ingress_path` | `string` | Yes | none | Path prefix for the Argo CD ingress route. |
| `ingress_group_name` | `string` | Yes | none | Name used for the ALB ingress group. |
| `server_replica_count` | `number` | No | `1` | Replica count for the Argo CD server deployment. |
| `repo_server_replica_count` | `number` | No | `1` | Replica count for the repo server deployment. |
| `controller_replica_count` | `number` | No | `1` | Replica count for the Argo CD controller deployment. |
| `application_set_controller_replica_count` | `number` | No | `1` | Replica count for the application set controller. |
| `enable_redis_hpa` | `bool` | No | `false` | Enables the Redis HA configuration in the Helm values. |

## Outputs

| Name | Description |
| --- | --- |
| `helm_release_name` | Name of the Helm release. |
| `helm_release_namespace` | Namespace used for Argo CD. |
| `ingress_name` | Name of the ingress resource created for Argo CD. |

## Notes

- This module assumes `kubectl` is installed and configured to the target EKS cluster when Terraform runs.
- The ingress template is designed for an AWS ALB ingress controller.
- The `helm_version` should match a valid Argo CD chart version available in the upstream chart repository.
