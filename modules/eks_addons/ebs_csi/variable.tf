variable "cluster_name" {
  type = string
  description = "Name of the EKS cluster."
}

variable "cluster_version" {
  type = string
  description = "Kubernetes version of the EKS cluster."
}

variable "resolve_conflicts_on_create" {
  type        = string
  description = "Conflict resolution behavior when creating the EKS addon."
  default     = "OVERWRITE"
}

variable "resolve_conflicts_on_update" {
  type        = string
  description = "Conflict resolution behavior when updating the EKS addon."
  default     = "PRESERVE"
}