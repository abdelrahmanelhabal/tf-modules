output "iam_role_arn" {
  description = "ARN of the IAM role used by the AWS Load Balancer Controller."
  value       = aws_iam_role.lab_controller_role.arn
}

output "iam_role_name" {
  description = "Name of the IAM role used by the AWS Load Balancer Controller."
  value       = aws_iam_role.lab_controller_role.name
}

output "helm_release_name" {
  description = "Name of the Helm release that installs the AWS Load Balancer Controller."
  value       = helm_release.alb-ingress.name
}
