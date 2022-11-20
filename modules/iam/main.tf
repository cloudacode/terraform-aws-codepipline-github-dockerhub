resource "aws_iam_role" "codebuild-iam-role" {
  name = var.iam_role_name

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Service": [
					"codebuild.amazonaws.com",
					"codepipeline.amazonaws.com"
				]
			},
			"Action": "sts:AssumeRole"
		}
	]
}
EOF
}

resource "aws_iam_role_policy" "codebuild-iam-policy" {
  role = aws_iam_role.codebuild-iam-role.name
  name = "${var.iam_role_name}-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.bucket_arn}",
        "${var.bucket_arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
          "codestar-connections:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "${var.bucket_arn}",
      "Action": [
          "kms:GenerateDataKey"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
          "*"
      ],
      "Action": [
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases",
        "codebuild:BatchPutCodeCoverages",
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
          "*"
      ],
      "Action": [
        "secretsmanager:GetSecretValue"
      ]
    }
  ]
}
POLICY
}
