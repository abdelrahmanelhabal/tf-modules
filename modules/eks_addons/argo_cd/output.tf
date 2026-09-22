output "helm_release_name" {
  description = "Name of the Helm release used to deploy Argo CD."
  value       = helm_release.argo_cd.name
}

output "helm_release_namespace" {
  description = "Namespace where Argo CD is installed."
  value       = helm_release.argo_cd.namespace
}

output "ingress_name" {
  description = "Name of the Kubernetes ingress created for Argo CD."
  value       = "argocd-ingress"
}
