provider "aws" {
  region = "us-east-1"
}

# plan - execute
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "my-s3-bucket-coconut-bucket-0809"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  force_destroy = false
  object_lock_enabled = false
}

resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user_updated"
}



# STATE
# DESIRED - KNOWN - ACTUAL

#   access_key = "AKIAWHMZVV7EM7QNEWPR"
#   secret_key = "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"