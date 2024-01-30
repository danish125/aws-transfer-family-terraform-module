module "sftp" {
  source = "https://github.com/danish125/aws-transfer-family-terraform-module.git"
  trusted_host_keys = [""]
  url = ""
  s3_bucket_arn = ""
  secret_arn = ""
  secret_id = ""
  logging_role_name = ""
  region = ""
  account_number = ""
  tags = {

  }
}
