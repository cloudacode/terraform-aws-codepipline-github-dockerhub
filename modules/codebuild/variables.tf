variable "bucket_name" {
  description = "Value of the Name tag for the Bucket"
  type        = string
}

variable "iam_role_arn" {
  description = "Value of the ARN for the IAM"
  type        = string
}

variable "codebuild_project_name" {
  description = "Value of the Name tag for the CodeBuild"
  type        = string
}

# https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
variable "codebuild_image_name" {
  description = "Value of the image name for the CodeBuild"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
}

variable "buildspec_file" {
  description = "Vaule of the buildspec file"
  type        = string
  default     = "buildspec.yml"
}

variable "code_repo" {
  description = "Vaule of the code repo URL"
  type        = string
}

variable "codebuild_compute_type" {
  description = "Value of the compute_type for the CodeBuild"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_type" {
  description = "Value of the type for the CodeBuild"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "codebuild_env_vars" {
  description = "Environment var for CodeBuild"
  type = object({
    IMAGE_REPO_NAME = string
  })
}

variable "codebuild_secret_env_vars" {
  description = "Secret environment var for CodeBuild, which is stored in SecretManager"
  type = object({
    DOCKERHUB_USERNAME = string
    DOCKERHUB_PASSWORD = string
  })
}
