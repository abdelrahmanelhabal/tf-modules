# EKS Node Group Module

This Terraform module creates an Amazon EKS managed node group and its worker-node IAM role.

The role receives the AWS-managed policies required for standard managed nodes:

- `AmazonEKSWorkerNodePolicy`
- `AmazonEKS_CNI_Policy`
- `AmazonEC2ContainerRegistryPullOnly`
- `SecretsManagerReadWrite`

## Usage

```hcl
module "eks_nodegroup" {
  source = "./eks_nodegroup"

  cluster_name              = module.eks.cluster_name
  eks_nodes_role_name       = "dev-eks-workers"
  node_group_name           = "dev-workers"
  node_group_subnets        = module.vpc.private_subnet_ids
  node_group_desired_size   = 2
  node_group_min_size       = 1
  node_group_max_size       = 4
  node_group_ami_type       = "AL2023_x86_64_STANDARD"
  node_group_instance_types = ["t3.medium"]
  node_group_disk_size      = 50
  node_group_version        = "1.31"
  node_group_role           = "worker"
}
```

`cluster_name` should come from the EKS cluster module output. This creates an implicit dependency on the cluster. The node group subnets should belong to the same VPC as the EKS cluster and should normally be private subnets.

## Inputs

| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `cluster_name` | `string` | Yes | Name of the EKS cluster. |
| `eks_nodes_role_name` | `string` | Yes | IAM role name for worker nodes. |
| `node_group_name` | `string` | Yes | EKS managed node group name. |
| `node_group_desired_size` | `number` | Yes | Desired number of nodes. |
| `node_group_max_size` | `number` | Yes | Maximum number of nodes. |
| `node_group_min_size` | `number` | Yes | Minimum number of nodes. |
| `node_group_ami_type` | `string` | Yes | EKS AMI type, such as `AL2023_x86_64_STANDARD`. |
| `node_group_disk_size` | `number` | Yes | Disk size in GiB for each node. |
| `node_group_instance_types` | `list(string)` | Yes | EC2 instance types for the node group. |
| `node_group_version` | `string` | Yes | Kubernetes version for the node group. Keep it compatible with the cluster version. |
| `node_group_subnets` | `list(string)` | Yes | Subnet IDs where nodes will launch. |
| `node_group_role` | `string` | Yes | Value for the Kubernetes `role` node label. |

## Outputs

| Name | Description |
| --- | --- |
| `node_group_name` | Name of the managed node group. |
| `node_group_arn` | ARN of the managed node group. |
| `node_role_arn` | ARN of the worker-node IAM role. |

## Notes

- `SecretsManagerReadWrite` grants worker nodes broad Secrets Manager permissions. Replace it with a narrowly scoped custom policy when only specific secrets are required.
- The node group version must match or be compatible with the EKS control-plane version.