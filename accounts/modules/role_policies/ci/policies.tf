data "aws_iam_policy_document" "ci_permissions" {
  statement {
    actions = [
      "ecr:*",
    ]

    resources = [
      "*",
    ]
  }

  dynamic "statement" {
    for_each = var.infra_bucket_arn == "" ? [] : [{}]

    content {
      actions = [
        "s3:*",
      ]

      resources = [
        var.infra_bucket_arn,
        "${var.infra_bucket_arn}/*",
      ]
    }
  }

  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      var.sbt_releases_bucket_arn,
      "${var.sbt_releases_bucket_arn}/*",
    ]
  }

  statement {
    actions = [
      "ecs:List*",
      "ecs:Describe*",
      "ecs:UpdateService",
      "ecs:TagResource"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ssm:PutParameter",
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/*",
    ]
  }

  statement {
    actions = [
      "ssm:GetParameter*",
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/*/images/*",
    ]
  }

  statement {
    actions = [
      "iam:GetUser",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "dynamodb:*",
    ]

    resources = [
      "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/wellcome-releases-*",
    ]
  }

  statement {
    actions = [
      "sns:Publish*",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_caller_identity" "current" {}
