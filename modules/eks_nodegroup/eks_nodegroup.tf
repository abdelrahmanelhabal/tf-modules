resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = var.node_group_subnets

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  ami_type       = var.node_group_ami_type
  instance_types = var.node_group_instance_types
  disk_size      = var.node_group_disk_size

  labels = {
    role = var.node_group_role
  }

  version = var.node_group_version

  depends_on = [
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_container_registry_read_only,
    aws_iam_role_policy_attachment.secret_manager_policy_for_eks_nodes,
  ]
}