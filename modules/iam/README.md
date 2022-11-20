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
| [aws_iam_role.codebuild-iam-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codebuild-iam-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | Value of the Bucket ARN | `string` | n/a | yes |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Value of the Name tag for the IAM | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_iam_role_arn"></a> [codebuild\_iam\_role\_arn](#output\_codebuild\_iam\_role\_arn) | IAM arn for codebuild |
| <a name="output_codebuild_iam_role_name"></a> [codebuild\_iam\_role\_name](#output\_codebuild\_iam\_role\_name) | IAM role name for codebuild |
<!-- END_TF_DOCS -->