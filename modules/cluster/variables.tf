variable "eks_cluster_role_arn" {
  type        = string
}

variable "private_subnets_id" {
type = list(string)
}
variable "security_group_id" {}
variable "project" {}
variable "tags" {
  
}
