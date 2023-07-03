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
    public_subnets_id   = ["public-subnet"]
    security_group_id   = "sg-id"
  }
}


dependency "iam-roles" {
  config_path = "../iam-roles"
  mock_outputs = {
    eks_cluster_role_arn = "arn:aws:eks:us-east-1:666666666666:cluster/dev"
  }
}

inputs = {
  eks_cluster_role_arn = dependency.iam-roles.outputs.eks_cluster_role_arn
  private_subnets_id   = dependency.vpc.outputs.private_subnets_id
  public_subnets_id    = dependency.vpc.outputs.public_subnets_id
  security_group_id    = dependency.vpc.outputs.security_group_id
}
