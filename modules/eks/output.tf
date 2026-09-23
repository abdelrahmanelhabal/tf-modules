output "cluster_name" {
	description = "Name of the EKS cluster."
	value       = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
	description = "API server endpoint for the EKS cluster."
	value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_certificate_authority_data" {
	description = "Base64-encoded certificate authority data for the EKS cluster."
	value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_role_arn" {
	description = "ARN of the IAM role used by the EKS control plane."
	value       = aws_iam_role.eks_role.arn
}

output "oidc_provider_arn" {
	description = "ARN of the IAM OIDC provider associated with the EKS cluster."
	value       = aws_iam_openid_connect_provider.oidc.arn
}

output "oidc_provider_url" {
  description = "URL of the OIDC provider associated with the EKS cluster."
  value       = aws_iam_openid_connect_provider.oidc.url
}