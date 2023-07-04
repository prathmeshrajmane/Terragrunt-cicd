variable "eks_master_role_arn" {}
variable "eks_worker_role_arn" {
  type        = string
}

variable "private_subnets_id" {
type = list(string)
}
variable "security_group_id" {}
variable "project" {}
variable "vpc-id" {
   type = string
}
variable "tags" {
  
}
