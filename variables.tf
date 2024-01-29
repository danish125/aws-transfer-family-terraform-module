variable "trusted_host_keys" {
  default = []
  description = "array of portion of public host keys "
}
variable "url" {
  description = "endpoint of the SFTP server"
}
variable "s3_bucket_arn" {
  description = "source s3 bucket arn"
}
variable "secret_arn" {
  description = "arn of the server key or password secret"
}
variable "secret_id" {
  description = "id of the server key or password secret"
}
variable "enable_cloudtrail_events" {
  default = false
  description = "pass true if cloudwatch logging is enabled for connector"

}
variable "logging_role_name" {
  description = "name of the role used for allowing put events into trails"
}
variable "region" {
  description = "aws region for cloudwatch log group"
}
variable "account_number" {
  description = "12 digit account number"
}
variable "tags" {
  default = {}
}