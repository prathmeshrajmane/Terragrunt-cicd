include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/cluster"
}


dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    private_subnets_id  = ["private-subnet"]
    security_group_id   = "sg-id"
  }
  mock_outputs_allowed_terraform_commands = ["init","plan"]
}


dependency "iam-roles" {
  config_path = "../iam-roles"
  mock_outputs = {
  # eks_cluster_role_arn = "arn:aws:iam::***:role/Test-Eks-Cluster-Role"
    eks_cluster_role_arn = "arn:aws:iam::123456789012:role/clusterrole"
  }
 mock_outputs_allowed_terraform_commands = ["init","plan"]
}

inputs = {
  eks_cluster_role_arn = dependency.iam-roles.outputs.eks_cluster_role_arn
  private_subnets_id   = dependency.vpc.outputs.private_subnets_id
  security_group_id    = dependency.vpc.outputs.security_group_id
}
