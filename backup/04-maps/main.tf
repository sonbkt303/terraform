variable "users" {
  default = {
    ravs : {
      country : "Netherlands"
    },
    tom : {
      country : "Us"
    },
    jane : {
      country : "India"
    }
  }
}


provider "aws" {}


resource "aws_iam_user" "my_iam_user" {
  for_each = var.users
  name     = each.key
  tags = {
    country : each.value.country
  }

}


