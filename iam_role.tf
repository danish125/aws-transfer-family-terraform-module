resource "aws_iam_role" "access_role" {
  name = var.access_role_name
  assume_role_policy = data.aws_iam_policy_document.connector_assume_role_policy.json

}

resource "aws_iam_role" "logging_role" {
  count = var.enable_cloudtrail_events ? 1 : 0
  name = var.logging_role_name
  assume_role_policy = data.aws_iam_policy_document.connector_assume_role_policy.json

}

data "aws_iam_policy_document" "connector_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "access_role_policy" {
  name = join("-", [var.access_role_name,"policy"])
  role = aws_iam_role.access_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowListingOfUserFolder",
        Action = [
            "s3:ListBucket",
            "s3:GetBucketLocation"
        ]
        Effect   = "Allow"
        Resource = [
            "${var.s3_bucket_arn}"
        ]
      },
      {
        Sid = "HomeDirObjectAccess",
        Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:DeleteObjectVersion",
            "s3:GetObjectVersion",
            "s3:GetObjectACL",
            "s3:PutObjectACL"
        ]
        Effect   = "Allow"
        Resource = [
            "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Sid = "GetConnectorSecretValue",
        Action = [
            "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = [
            "${var.secret_arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "logging_role_policy" {
  count = var.enable_cloudtrail_events ? 1 : 0
  name = join("-", [var.logging_role_name,"policy"])
  role = aws_iam_role.logging_role[0].id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Sid = "HomeDirObjectAccess",
        Action = [
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = [
            "arn:aws:logs:${var.region}:${var.account_number}:log-group:*"
        ]
      }
    ]
  })
}