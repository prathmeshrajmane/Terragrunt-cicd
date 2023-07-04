output "eks_master_role_arn" {
  description = "The arn of the eks master role"
  value       = aws_iam_role.master.arn
}

output "eks_worker_role_arn" {
  description = "The arn of the eks worker role"
  value       = aws_iam_role.worker.arn
}

