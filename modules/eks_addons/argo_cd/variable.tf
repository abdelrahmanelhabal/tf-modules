variable "helm_version" {
  description = "Version of the argo-cd Helm chart to install."
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS node group that Argo CD should wait for before installation."
  type        = string
}

variable "lb_security_group1" {
  description = "First security group ID to attach to the ALB ingress for Argo CD."
  type        = string
}

variable "lb_security_group2" {
  description = "Second security group ID to attach to the ALB ingress for Argo CD."
  type        = string
}

variable "lb_subnet1" {
  description = "First subnet ID that the ALB ingress should use."
  type        = string
}

variable "lb_subnet2" {
  description = "Second subnet ID that the ALB ingress should use."
  type        = string
}

variable "lb_domain_name" {
  description = "Domain name used by the Argo CD ingress host rule."
  type        = string
}

variable "lb_scheme" {
  description = "Load balancer scheme for the ingress, such as internal or internet-facing."
  type        = string
}

variable "ingress_path" {
  description = "Path prefix used by the Argo CD ingress rule."
  type        = string
}

variable "ingress_group_name" {
  description = "Name of the ALB ingress group for the Argo CD ingress."
  type        = string
}

variable "server_replica_count" {
  description = "Number of replicas for the Argo CD server deployment."
  type        = number
  default     = 1
}

variable "repo_server_replica_count" {
  description = "Number of replicas for the Argo CD repo-server deployment."
  type        = number
  default     = 1
}

variable "controller_replica_count" {
  description = "Number of replicas for the Argo CD controller deployment."
  type        = number
  default     = 1
}

variable "application_set_controller_replica_count" {
  description = "Number of replicas for the Argo CD application set controller deployment."
  type        = number
  default     = 1
}

variable "enable_redis_hpa" {
  description = "Whether to enable the Redis HA deployment for Argo CD."
  type        = bool
  default     = false
}
