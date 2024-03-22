
# output "my_s3_bucket_complete_details" {
#   value = aws_s3_bucket.my_s3_bucket
# }

# output "my_iam_user_complete_details" {
#   value = aws_iam_user.my_iam_user
# }


output "aws_security_group_http_server_details" {
  value = aws_security_group.http_server_sg
}