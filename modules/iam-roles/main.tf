# resource "aws_iam_role" "cluster" {
#   name = "${var.project}-Eks-Cluster-Role"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

resource "aws_iam_role" "cluster" {
  name = "${var.project}-Eks-Cluster-Role"
  assume_role_policy = file("ekscluster-role.json")
}

resource "aws_iam_policy_attachment" "AmazonEKSClusterPolicy" {
  name       = "ekspolicy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles      = [aws_iam_role.cluster.name]
}


# resource "kubernetes_config_map" "aws-auth" {
#   data = {
#     "mapRoles" = <<EOT
# - rolearn: arn:aws:iam::653060988075:role/Metadata-Eks-Cluster-Role
#   username: system:node:{{EC2PrivateDNSName}}
#   groups:
#     - system:bootstrappers
#     - system:nodes
#       # Therefore, before you specify rolearn, remove the path. For example, change arn:aws:iam::<123456789012>:role/<team>/<developers>/<eks-admin> to arn:aws:iam::<123456789012>:role/<eks-admin>. FYI:https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting_iam.html#security-iam-troubleshoot-ConfigMap
# # Add as below 
# - rolearn: Prathmesh
#   username: Prathmesh
#   groups: # REF: https://kubernetes.io/ja/docs/reference/access-authn-authz/rbac/
#     - Prathmesh
# EOT
#   }

#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }
# }




