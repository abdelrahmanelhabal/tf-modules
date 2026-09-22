resource "helm_release" "argo_cd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.helm_version
  namespace        = "argocd"
  create_namespace = true
  timeout          = 1500
  values           = [data.template_file.values.rendered]
}

data "template_file" "ingress" {
  template = file("${path.module}/template/argocd_ingress.yaml")
  vars = {
    lb_security_group1 = var.lb_security_group1
    lb_security_group2 = var.lb_security_group2
    lb_subnet1         = var.lb_subnet1
    lb_subnet2         = var.lb_subnet2
    lb_domain_name     = var.lb_domain_name
    lb_scheme          = var.lb_scheme
    ingress_path       = var.ingress_path
    ingress_group_name = var.ingress_group_name
  }
}

data "template_file" "values" {
  template = file("${path.module}/template/values.yaml")
  vars = {
    server_replica_count          = var.server_replica_count
    repo_server_replica_count     = var.repo_server_replica_count
    controller_replica_count      = var.controller_replica_count
    application_set_replica_count = var.application_set_controller_replica_count
    enable_redis_hpa              = var.enable_redis_hpa
  }
}

resource "null_resource" "argocd_config" {
  depends_on = [helm_release.argo_cd]

  provisioner "local-exec" {
    command = <<EOF
kubectl apply -f - <<'YAML'
${data.template_file.ingress.rendered}
YAML
EOF
  }
}