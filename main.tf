locals {
  git_repo_short_name = trimsuffix(element(split("https://github.com/", var.git_clone_http_url), 1), ".git")
  project_name_suffix = lower(replace(replace(local.git_repo_short_name, "/", "-"), "_", "-"))
}

resource "random_id" "random-id" {
  byte_length = 2
}

resource "aws_s3_bucket" "codebuild-pipeline-bucket" {
  bucket = "${local.project_name_suffix}-${random_id.random-id.dec}-log"
}

resource "aws_s3_bucket_acl" "codebuild-pipeline-bucket-acl" {
  bucket = aws_s3_bucket.codebuild-pipeline-bucket.id
  acl    = "private"
}

resource "aws_secretsmanager_secret" "dockerhub-secret" {
  name        = "${local.project_name_suffix}-${random_id.random-id.dec}-dockerhub-creds"
  description = "Dockerhub login credentials"
}

resource "aws_secretsmanager_secret_version" "dockerhub-login-creds" {
  secret_id     = aws_secretsmanager_secret.dockerhub-secret.id
  secret_string = jsonencode(var.dockerhub_creds)
}

module "codebuild-pipeline-iam-role" {
  source        = "./modules/iam"
  iam_role_name = "${local.project_name_suffix}-role"
  bucket_arn    = aws_s3_bucket.codebuild-pipeline-bucket.arn
}

module "codebuild-amd64-project" {
  source = "./modules/codebuild"

  bucket_name            = aws_s3_bucket.codebuild-pipeline-bucket.id
  iam_role_arn           = module.codebuild-pipeline-iam-role.codebuild_iam_role_arn
  code_repo              = var.git_clone_http_url
  codebuild_project_name = "${local.project_name_suffix}-amd64"
  codebuild_image_name   = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
  codebuild_env_vars = {
    IMAGE_REPO_NAME = var.dockerhub_repo
  }
  codebuild_secret_env_vars = {
    DOCKERHUB_USERNAME = "${aws_secretsmanager_secret.dockerhub-secret.name}:username"
    DOCKERHUB_PASSWORD = "${aws_secretsmanager_secret.dockerhub-secret.name}:password"
  }
}

module "codebuild-arm64-project" {
  source = "./modules/codebuild"

  bucket_name            = aws_s3_bucket.codebuild-pipeline-bucket.id
  iam_role_arn           = module.codebuild-pipeline-iam-role.codebuild_iam_role_arn
  code_repo              = var.git_clone_http_url
  codebuild_project_name = "${local.project_name_suffix}-arm64"
  codebuild_image_name   = "aws/codebuild/amazonlinux2-aarch64-standard:2.0"
  codebuild_type         = "ARM_CONTAINER"
  codebuild_env_vars = {
    IMAGE_REPO_NAME = var.dockerhub_repo
  }
  codebuild_secret_env_vars = {
    DOCKERHUB_USERNAME = "${aws_secretsmanager_secret.dockerhub-secret.name}:username"
    DOCKERHUB_PASSWORD = "${aws_secretsmanager_secret.dockerhub-secret.name}:password"
  }
}

module "codebuild-manifest-project" {
  source = "./modules/codebuild"

  bucket_name            = aws_s3_bucket.codebuild-pipeline-bucket.id
  iam_role_arn           = module.codebuild-pipeline-iam-role.codebuild_iam_role_arn
  code_repo              = var.git_clone_http_url
  codebuild_project_name = "${local.project_name_suffix}-manifest"
  codebuild_image_name   = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
  buildspec_file         = "buildspec-manifest.yml"
  codebuild_env_vars = {
    IMAGE_REPO_NAME = var.dockerhub_repo
  }
  codebuild_secret_env_vars = {
    DOCKERHUB_USERNAME = "${aws_secretsmanager_secret.dockerhub-secret.name}:username"
    DOCKERHUB_PASSWORD = "${aws_secretsmanager_secret.dockerhub-secret.name}:password"
  }
}

resource "aws_codestarconnections_connection" "codestare-conn" {
  name          = "${local.project_name_suffix}-conn"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "codepipeline-project" {
  name     = "${local.project_name_suffix}-pipeline"
  role_arn = module.codebuild-pipeline-iam-role.codebuild_iam_role_arn

  artifact_store {
    location = aws_s3_bucket.codebuild-pipeline-bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.codestare-conn.arn
        FullRepositoryId = local.git_repo_short_name
        BranchName       = var.git_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "build_amd64"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration = {
        ProjectName = module.codebuild-amd64-project.codebuild_project_name
      }
    }
    action {
      name            = "build_arm64"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration = {
        ProjectName = module.codebuild-arm64-project.codebuild_project_name
      }
    }
  }

  stage {
    name = "Manifest"

    action {
      name            = "manifest"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration = {
        ProjectName = module.codebuild-manifest-project.codebuild_project_name
      }
    }
  }
}
