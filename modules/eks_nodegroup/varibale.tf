variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster to which the node group belongs"
}

variable "eks_nodes_role_name" {
  type        = string
  description = "The name of the IAM role used by the EKS worker nodes"
}

variable "node_group_name" {
  type        = string
  description = "The name of the EKS node group"
}

variable "node_group_desired_size" {
  type        = number
  description = "The desired number of worker nodes in the node group"
}

variable "node_group_max_size" {
  type        = number
  description = "The maximum number of worker nodes in the node group"
}

variable "node_group_min_size" {
  type        = number
  description = "The minimum number of worker nodes in the node group"
}

variable "node_group_ami_type" {
  type        = string
  description = "The AMI type for the node group"
}

variable "node_group_disk_size" {
  type        = number
  description = "The disk size for each node in the node group"
}

variable "node_group_instance_types" {
  type        = list(string)
  description = "List of EC2 instance types for the node group"
}

variable "node_group_version" {
  type        = string
  description = "The Kubernetes version for the node group"
}

variable "node_group_subnets" {
  type        = list(string)
  description = "List of subnet IDs where the node group instances will be launched"
}

variable "node_group_role" {
  type        = string
  description = "Kubernetes label value assigned to the node group role label"
}