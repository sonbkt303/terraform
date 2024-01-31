variable "names" {
  default = ["ranga", "mike", "jane"]
}

variable "iam_user_name_prefix" {
  type    = string # any, number, bool, list, map, set, object, tuple 
  default = "my_iam_user"
}


provider "aws" {
  region     = "us-east-1"
}


resource "aws_iam_user" "my_iam_user" {
  # count = length(var.names)
  # name  = var.names[count.index]
  # name  = "${var.environment}_${var.iam_user_name_prefix}_${count.index}"
  for_each = toset(var.names)
  name = each.value
}


