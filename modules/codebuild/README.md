<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.39.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.39.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.codebuild-project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Value of the Name tag for the Bucket | `string` | n/a | yes |
| <a name="input_buildspec_file"></a> [buildspec\_file](#input\_buildspec\_file) | Vaule of the buildspec file | `string` | `"buildspec.yml"` | no |
| <a name="input_code_repo"></a> [code\_repo](#input\_code\_repo) | Vaule of the code repo URL | `string` | n/a | yes |
| <a name="input_codebuild_compute_type"></a> [codebuild\_compute\_type](#input\_codebuild\_compute\_type) | Value of the compute\_type for the CodeBuild | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_codebuild_env_vars"></a> [codebuild\_env\_vars](#input\_codebuild\_env\_vars) | Environment var for CodeBuild | <pre>object({<br>    IMAGE_REPO_NAME = string<br>  })</pre> | n/a | yes |
| <a name="input_codebuild_image_name"></a> [codebuild\_image\_name](#input\_codebuild\_image\_name) | Value of the image name for the CodeBuild | `string` | `"aws/codebuild/amazonlinux2-x86_64-standard:4.0"` | no |
| <a name="input_codebuild_project_name"></a> [codebuild\_project\_name](#input\_codebuild\_project\_name) | Value of the Name tag for the CodeBuild | `string` | n/a | yes |
| <a name="input_codebuild_secret_env_vars"></a> [codebuild\_secret\_env\_vars](#input\_codebuild\_secret\_env\_vars) | Secret environment var for CodeBuild, which is stored in SecretManager | <pre>object({<br>    DOCKERHUB_USERNAME = string<br>    DOCKERHUB_PASSWORD = string<br>  })</pre> | <pre>{<br>  "DOCKERHUB_PASSWORD": "dockerhub:password",<br>  "DOCKERHUB_USERNAME": "dockerhub:username"<br>}</pre> | no |
| <a name="input_codebuild_type"></a> [codebuild\_type](#input\_codebuild\_type) | Value of the type for the CodeBuild | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | Value of the ARN for the IAM | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_project_name"></a> [codebuild\_project\_name](#output\_codebuild\_project\_name) | project name of codebuild |
<!-- END_TF_DOCS -->

## Reference

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection
