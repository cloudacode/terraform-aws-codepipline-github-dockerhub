# AWS Codepipeline terraform module for building multi architecture docker images

Terraform module which build multiple architecture docker images using AWS CodeBuild and AWS CodePipeline

---
# Terraform for building multi-architecture docker images using AWS CodeBuild and AWS CodePipeline

With CodePipeline and CodeBuild, we can automate the creation of architecture-specific Docker images that you can push to DockerHub. The following diagram shows the architecture.

![multi-architecture-build](./multi-architecture-build.jpg)

## Who created this Module?

Module is maintained by [KC Chang](https://github.com/cloudacode).

## How to use this Module

Root module calls these modules which can also be used separately to create independent resources:

- [codebuild](./modules/codebuild/) - creates CodeBuild projects
- [iam](./modules/iam/) - creates IAM role and Policy for projects

### Usage

```hcl
module "codebuild-pipeline-iam-role" {
  source        = "cloudacode/terraform-aws-codepipline-github-dockerhub/iam"
  iam_role_name = "${local.project_name_suffix}-role"
  bucket_arn    = aws_s3_bucket.codebuild-pipeline-bucket.arn
}

module "codebuild-amd64-project" {
  source = "cloudacode/terraform-aws-codepipline-github-dockerhub/codebuild"

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
  source = "cloudacode/terraform-aws-codepipline-github-dockerhub/codebuild"

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
  source = "cloudacode/terraform-aws-codepipline-github-dockerhub/codebuild"

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
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.39.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_codebuild-amd64-project"></a> [codebuild-amd64-project](#module\_codebuild-amd64-project) | ../modules/codebuild | n/a |
| <a name="module_codebuild-arm64-project"></a> [codebuild-arm64-project](#module\_codebuild-arm64-project) | ../modules/codebuild | n/a |
| <a name="module_codebuild-manifest-project"></a> [codebuild-manifest-project](#module\_codebuild-manifest-project) | ../modules/codebuild | n/a |
| <a name="module_codebuild-pipeline-iam-role"></a> [codebuild-pipeline-iam-role](#module\_codebuild-pipeline-iam-role) | ../modules/iam | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_codepipeline.codepipeline-project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codestarconnections_connection.codestare-conn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |
| [aws_s3_bucket.codebuild-pipeline-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.codebuild-pipeline-bucket-acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_secretsmanager_secret.dockerhub-secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.dockerhub-login-creds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_id.random-id](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dockerhub_creds"></a> [dockerhub\_creds](#input\_dockerhub\_creds) | The credentials of the DockerHub | <pre>object({<br>    username = string<br>    password = string<br>  })</pre> | n/a | yes |
| <a name="input_dockerhub_repo"></a> [dockerhub\_repo](#input\_dockerhub\_repo) | The name of the Docker Registry Repo | `string` | `"cloudacode/python-docker"` | yes |
| <a name="input_git_branch"></a> [git\_branch](#input\_git\_branch) | The name of the Git branch to be triggered | `string` | `"master"` | yes |
| <a name="input_git_clone_http_url"></a> [git\_clone\_http\_url](#input\_git\_clone\_http\_url) | The name of the GitHub Repo HTTP URL | `string` | `"https://github.com/cloudacode/python-docker.git"` | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region of the project | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_amd64_project_name"></a> [codebuild\_amd64\_project\_name](#output\_codebuild\_amd64\_project\_name) | project name for cloudbuild |
| <a name="output_codebuild_arm64_project_name"></a> [codebuild\_arm64\_project\_name](#output\_codebuild\_arm64\_project\_name) | project name for cloudbuild |
| <a name="output_codebuild_manifest_project_name"></a> [codebuild\_manifest\_project\_name](#output\_codebuild\_manifest\_project\_name) | project name for cloudbuild |
| <a name="output_codepipeline_project_name"></a> [codepipeline\_project\_name](#output\_codepipeline\_project\_name) | project name for cloudpipeline |
| <a name="output_codestart_connection_name"></a> [codestart\_connection\_name](#output\_codestart\_connection\_name) | name for codestar connection |
| <a name="output_dockerhub_secretmanager_name"></a> [dockerhub\_secretmanager\_name](#output\_dockerhub\_secretmanager\_name) | n/a |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | name for s3 bucket |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/cloudacode/terraform-aws-codepipline-github-dockerhub/blob/main/LICENSE) for full details.
