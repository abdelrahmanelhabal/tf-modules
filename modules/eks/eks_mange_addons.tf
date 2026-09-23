locals {
  oidc_provider_url = replace(aws_iam_openid_connect_provider.oidc.url , "https://" , "")
}

data "aws_iam_policy_document" "vpc_cni_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"
  
    
    condition {
      test = "StringLike"
      variable = "${local.oidc_provider_url}:aud"
      values = ["sts.amazonaws.com"]
    }

    condition {
      test = "StringLike"
      variable = "${local.oidc_provider_url}:sub"
      values = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc.arn]
      type = "Federated"
    }
  }
}

resource "aws_iam_role" "vpc_cni_role" {
  name = "${var.eks_role_name}-CNT_ROLE"
  assume_role_policy = data.aws_iam_policy_document.vpc_cni_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cni_ploicy_attachment" {
  role = aws_iam_role.vpc_cni_role.name 
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


data "aws_eks_addon_version" "vpc_cni" {
  addon_name = "vpc-cni"
  kubernetes_version = var.cluster_version
}

resource "aws_eks_addon" "vpc_cni" {
  addon_name = "vpc-cni"
  cluster_name = var.cluster_name
  addon_version = data.aws_eks_addon_version.vpc_cni.version
  service_account_role_arn = aws_iam_role.vpc_cni_role.arn 
  resolve_conflicts_on_create = var.eks_addon_creation_conflict_behavior
  resolve_conflicts_on_update = var.eks_addon_update_conflict_behavior


  depends_on = [ aws_eks_cluster.eks_cluster ]
}

data "aws_eks_addon_version" "kube_proxy" {
  addon_name = "kube-proxy"
  kubernetes_version = var.cluster_version
}

resource "aws_eks_addon" "kube_proxy" {
  addon_name = "kube-proxy"
  cluster_name = var.cluster_name
  addon_version = data.aws_eks_addon_version.kube_proxy.version
  resolve_conflicts_on_create = var.eks_addon_creation_conflict_behavior
  resolve_conflicts_on_update = var.eks_addon_update_conflict_behavior 

  
  depends_on = [ aws_eks_cluster.eks_cluster ] 
}

data "aws_eks_addon_version" "core_dns" {
  addon_name = "coredns"
  kubernetes_version = var.cluster_version
}

resource "aws_eks_addon" "core_dns" {
  addon_name = "coredns"
  cluster_name = var.cluster_name
  addon_version = data.aws_eks_addon_version.core_dns.version
  resolve_conflicts_on_create = var.eks_addon_creation_conflict_behavior
  resolve_conflicts_on_update = var.eks_addon_update_conflict_behavior  

  depends_on = [ aws_eks_cluster.eks_cluster ]
}