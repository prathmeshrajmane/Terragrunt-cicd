output "eks_cluster_role_arn" {
  description = "The arn of the eks cluster role"
  value       = aws_iam_role.cluster.arn
}
