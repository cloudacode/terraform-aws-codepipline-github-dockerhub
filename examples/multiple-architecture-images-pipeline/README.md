# Complete CodeBuild and CodePieline example for building multiple architecture docker images.
Configuration in this directory creates cloudbuild projects per architecture(arm64, amd64), cloudpipeline project, and IAM role.

## Usage
```hcl
# initalize the terraform and set the modules
terraform init
# set dockerhub creds as os environment
export TF_VAR_dockerhub_creds='{username="<your_dockerhub_user>",password="<your_dockerhub_password>"}'
# simulate the changes and verify
terraform plan
# apply the terraform code to deploy defined resources in real world
terraform apply
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
| <a name="input_dockerhub_repo"></a> [dockerhub\_repo](#input\_dockerhub\_repo) | The name of the Docker Registry Repo | `string` | `"cloudacode/python-docker"` | no |
| <a name="input_git_branch"></a> [git\_branch](#input\_git\_branch) | The name of the Git branch to be triggered | `string` | `"master"` | no |
| <a name="input_git_clone_http_url"></a> [git\_clone\_http\_url](#input\_git\_clone\_http\_url) | The name of the GitHub Repo HTTP URL | `string` | `"https://github.com/cloudacode/python-docker.git"` | no |
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
