variable "eks_alb_role_name" {
  type        = string
  description = "Name of the IAM role that will be created for the AWS Load Balancer Controller."
}

variable "cluster_name" {
  type        = string
  description = "Name of the Amazon EKS cluster that the AWS Load Balancer Controller will manage."
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the cluster's IAM OIDC provider, used to trust the service account role."
}

variable "oidc_provider_url" {
  type        = string
  description = "Full OIDC issuer URL for the EKS cluster, used in the IAM trust policy condition."
}

variable "alb_version" {
  type        = string
  description = "Version of the aws-load-balancer-controller Helm chart to install."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the AWS Load Balancer Controller will create and manage load balancers."
}