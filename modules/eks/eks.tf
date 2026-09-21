locals {
  eks_tags = merge(
    var.tags,
    {
        Name = var.cluster_name
        Environment = var.env 
        ManagedBy = "Terraform"
        Service = "eks"
    }
  )
}

resource "aws_eks_cluster" "eks_cluster" {
   name = var.cluster_name
   role_arn = aws_iam_role.eks_role.arn 
   version = var.cluster_version 
   enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

   encryption_config {
    provider {
      key_arn = aws_kms_key.kms_key.arn 
    }
    resources = ["secrets"]
   }

   access_config {
     authentication_mode = "API_AND_CONFIG_MAP"
   } 

   vpc_config {
     subnet_ids = var.subnets_ids 
     security_group_ids = var.eks_sg_ids 
     endpoint_private_access = var.endpoint_private_access
     endpoint_public_access =  var.endpoint_public_access
   }
  provisioner "local-exec" {
    command = <<EOT
        aws eks --region ${var.infrastructure_region} update-kubeconfig --name ${var.cluster_name} 
    EOT
  }
  
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]

  tags       = local.eks_tags
}
