output "codebuild_project_name" {
  description = "project name of codebuild"
  value       = aws_codebuild_project.codebuild-project.name
}
