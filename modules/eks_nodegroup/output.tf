output "node_group_name" {
  description = "Name of the EKS managed node group."
  value       = aws_eks_node_group.node_group.node_group_name
}

output "node_group_arn" {
  description = "ARN of the EKS managed node group."
  value       = aws_eks_node_group.node_group.arn
}

output "node_role_arn" {
  description = "ARN of the IAM role used by the worker nodes."
  value       = aws_iam_role.eks_nodes_role.arn
}
