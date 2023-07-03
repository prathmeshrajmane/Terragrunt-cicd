resource "aws_eks_cluster" "cluster" {
  name     = "${var.project}-eks-cluster"
  role_arn =  var.eks_cluster_role_arn

  vpc_config {
    security_group_ids      = [var.security_group_id]
    subnet_ids              = flatten([var.private_subnets_id[*]])
    #subnet_ids              = flatten([var.public_subnets_id[*] , var.private_subnets_id[*]])
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  tags = merge(
    var.tags
  )
}
