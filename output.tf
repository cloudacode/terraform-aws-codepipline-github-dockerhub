output "codebuild_amd64_project_name" {
  description = "The project name for cloudbuild amd64"
  value       = try(module.codebuild-amd64-project.codebuild_project_name, {})
}

output "codebuild_arm64_project_name" {
  description = "The project name for cloudbuild arm64"
  value       = try(module.codebuild-arm64-project.codebuild_project_name, {})
}

output "codebuild_manifest_project_name" {
  description = "The project name for cloudbuild manifest"
  value       = try(module.codebuild-manifest-project.codebuild_project_name, {})
}

output "codepipeline_project_name" {
  description = "The project name for cloudpipeline"
  value       = try(aws_codepipeline.codepipeline-project.name, {})
}

output "codestart_connection_name" {
  description = "The name of codestar connection"
  value       = try(aws_codestarconnections_connection.codestare-conn.name, {})
}

output "s3_bucket_name" {
  description = "The name of s3 bucket"
  value       = aws_s3_bucket.codebuild-pipeline-bucket.bucket
}

output "dockerhub_secretmanager_name" {
  description = "The secretmanager name of dockerhub login creds"
  value       = aws_secretsmanager_secret.dockerhub-secret.name
}
