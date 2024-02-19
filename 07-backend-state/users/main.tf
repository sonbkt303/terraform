provider "aws" {}

terraform {
  backend "s3" {
    bucket = "dev-applications-backend-state-01"
    key = "07-backend-state/users/backend-state"
    dynamodb_table = "dev_application_locks"
    encrypt = true
  }
}

resource "aws_iam_user" "my_iam_user" {
    name = "${terraform.workspace}_my_iam_user_abc"
}
