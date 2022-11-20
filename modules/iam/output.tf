output "codebuild_iam_role_name" {
  description = "IAM role name for codebuild"
  value       = aws_iam_role.codebuild-iam-role.name
}

output "codebuild_iam_role_arn" {
  description = "IAM arn for codebuild"
  value       = aws_iam_role.codebuild-iam-role.arn
}
