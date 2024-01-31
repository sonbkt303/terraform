provider "aws" {
    region = "us-east-1"
    access_key = "AKIAWHMZVV7EGHRUGOPI"
    secret_key = "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"
  
}

# plan - execute
resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "my-s3-bucket-coconut-bucket-0809"
    versioning {
        enabled = true
    }
}

resource "aws_iam_user" "my_iam_user" {
    name = "my_iam_user_abc_updated"
}



# STATE
# DESIRED - KNOWN - ACTUAL