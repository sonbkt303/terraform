provider "aws" {
  region = "us-east-1"
}
variable "names" {
  default = ["ravs", "sats", "ranga", "tom", "jane"]
}

variable "my_iam_user_prefix" {
  type    = string
  default = "my_iam_user"
}

variable "environment" {
  default = "dev"
}

# plan - execute
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "my-s3-bucket-coconut-bucket-0809"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }


  force_destroy       = false
  object_lock_enabled = false
}

resource "aws_iam_user" "my_iam_user" {
  # count = length(var.names)
  # name = "${var.environment}_${var.names[count.index]}"
  # path = "/system/test/"
  for_each = toset(var.names)
  name = each.value
}



# STATE
# DESIRED - KNOWN - ACTUAL

#   access_key = "AKIAWHMZVV7EM7QNEWPR"
#   secret_key = "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"