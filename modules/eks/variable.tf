variable "eks_role_name" {
  type = string 
  description = "The EKS role name"
}

variable "env" {
  type = string 
  description = "The environment name"
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "cluster_name" {
  type = string 
  description = "The name of EKS cluster"
}

variable "cluster_version" {
  type = string 
  description = "The version of EKS cluster"
}

variable "subnets_ids" {
    type = list(string)
    description = "Subnet IDs where the EKS cluster nodes will be launched"
}

variable "eks_sg_ids" {
  type = list(string)
  description = "Security group IDs to associate with EKS cluster control plane"
}

variable "endpoint_private_access" {
  type = bool 
  description = "Indicates whether the Amazon EKS private API server endpoint is enabled"
}

variable "endpoint_public_access" {
  type = bool 
  description = "Indicates whether the Amazon EKS public API server endpoint is enabled"
}

variable "infrastructure_region" {
  type = string
  description = "The region where the EKS cluster will be created"
}

variable "eks_addon_creation_conflict_behavior" {
  type = string 
  default = "OVERWRITE"
  description = "Behavior when creating an EKS addon that already exists"
}

variable "eks_addon_update_conflict_behavior" {
  type        = string
  default     = "PRESERVE"
  description = "Behavior when updating an existing EKS addon"
}