data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "tls_certificate" "tls_cert" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}