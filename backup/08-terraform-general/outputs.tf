
# output "my_s3_bucket_complete_details" {
#   value = aws_s3_bucket.my_s3_bucket
# }

# output "my_iam_user_complete_details" {
#   value = aws_iam_user.my_iam_user
# }


output "http_server_public_dns" {
  value = values(aws_instance.http_servers).*.id
}


output "aws_security_group_elb_sg_id" {
  value = aws_security_group.elb_sg.id
}

output "elb_public_dns" {
  value = aws_elb.elb
}