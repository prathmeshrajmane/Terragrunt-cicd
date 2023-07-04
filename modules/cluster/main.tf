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
    source_security_group_ids = aws_security_group.worker_node_sg.id
  } 
  
  labels =  tomap({env = "dev"})
  
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }



resource "aws_security_group" "worker_node_sg" {
  name        = "eks-test"
  description = "Allow ssh inbound traffic"
  vpc_id      =  var.vpc-id

  ingress {
    description      = "ssh access to public"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}
