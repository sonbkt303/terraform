provider "aws" {}

resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user_abc"
}

