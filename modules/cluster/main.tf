resource "aws_eks_cluster" "cluster" {
  name     = "${var.project}-eks-cluster"
  role_arn =  var.eks_master_role_arn

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

resource "aws_eks_node_group" "backend" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "dev"
  node_role_arn   = var.eks_worker_role_arn
  subnet_ids              = flatten([var.private_subnets_id[*]])
  #subnet_ids = [var.subnet_ids[0],var.subnet_ids[1]]
  capacity_type = "ON_DEMAND"
  disk_size = "20"
  instance_types = ["t2.small"]
  remote_access {
    ec2_ssh_key = "rtp-03"
    source_security_group_ids = [var.security_group_id]
  } 
  
  labels =  tomap({env = "dev"})
  
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}

resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
data = {
    mapRoles = <<YAML
- rolearn: ${arn:aws:iam::772292804745:role/ed-eks-worker}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
- rolearn: ${arn:aws:iam::772292804745:role/prathmesh}
  username: kubectl
  groups:
    - system:masters
YAML
  }
}
