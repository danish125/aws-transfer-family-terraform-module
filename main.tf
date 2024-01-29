resource "aws_transfer_connector" "example" {
  access_role = aws_iam_role.access_role.arn
  logging_role = var.enable_cloudtrail_events ? aws_iam_role.logging_role[0].arn : null
  sftp_config {
    trusted_host_keys = var.trusted_host_keys
    user_secret_id    = var.secret_id
  }
  url = var.url
  tags = var.tags
}