data "template_file" "service_account" {
  depends_on = [ var.node_group_name, aws_iam_role.load_balancer_controller_role ]
  template = file("${path.module}/template/alb-service-account.yaml")

  vars = {
    eks_alb_role_arn = "${aws_iam_role.load_balancer_controller_role.arn}"
  }
}



resource "null_resource" "alb_ingress_config" {
  depends_on = [var.node_group_name]

  provisioner "local-exec" {
    command = <<EOT
            kubectl apply -k "https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller//crds?ref=master"

            echo  '${data.template_file.service_account.rendered}' | kubectl apply -f -
    EOT
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
            kubectl delete -k "https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller//crds?ref=master"
            kubectl delete serviceaccount -n kube-system aws-load-balancer-controller
    EOT
  }
}

resource "helm_release" "alb-ingress" {
  name       = "alb-ingress"
  version    = var.alb_version 
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [null_resource.alb_ingress_config]

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