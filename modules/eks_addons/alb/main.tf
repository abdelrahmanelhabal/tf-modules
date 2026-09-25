locals {
  alb_service_account_manifest = templatefile("${path.module}/template/alb-service-account.yaml", {
    eks_alb_role_arn = aws_iam_role.load_balancer_controller_role.arn
  })
}

resource "null_resource" "alb_config" {
  depends_on = [aws_iam_role.load_balancer_controller_role]

  provisioner "local-exec" {
    command = <<EOF
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
echo '${local.alb_service_account_manifest}' | kubectl apply -f -
EOF
  }

  provisioner "local-exec" {
    when = destroy

    command = <<EOF
kubectl delete -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master" --ignore-not-found
kubectl delete serviceaccount -n kube-system aws-load-balancer-controller --ignore-not-found
EOF
  }
}

resource "helm_release" "alb-ingress" {
  depends_on = [
    aws_iam_role.load_balancer_controller_role,
    null_resource.alb_config
  ]

  name       = "alb-ingress"
  repository = "https://aws.github.io/eks-charts"
  version    = var.alb_version
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }
}