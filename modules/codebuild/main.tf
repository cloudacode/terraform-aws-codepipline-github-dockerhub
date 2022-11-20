resource "aws_codebuild_project" "codebuild-project" {
  name           = var.codebuild_project_name
  description    = "${var.codebuild_project_name} project"
  build_timeout  = "5"
  queued_timeout = "5"

  service_role = var.iam_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = var.codebuild_compute_type
    image                       = var.codebuild_image_name
    type                        = var.codebuild_type
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = var.codebuild_env_vars
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }

    dynamic "environment_variable" {
      for_each = var.codebuild_secret_env_vars
      content {
        name  = environment_variable.key
        value = environment_variable.value
        type  = "SECRETS_MANAGER"
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${var.bucket_name}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = var.code_repo
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }

    buildspec = var.buildspec_file
  }

  source_version = "master"
}
